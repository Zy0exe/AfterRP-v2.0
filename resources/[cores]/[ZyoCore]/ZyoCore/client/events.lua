-- ZyoCore Command Events
RegisterNetEvent('ZyoCore:Command:TeleportToPlayer')
AddEventHandler('ZyoCore:Command:TeleportToPlayer', function(othersource)
    local coords = ZyoCore.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
    local entity = GetPlayerPed(-1)
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, coords.a)
end) 

RegisterNetEvent('ZyoCore:Command:TeleportToCoords')
AddEventHandler('ZyoCore:Command:TeleportToCoords', function(x, y, z)
    local entity = GetPlayerPed(-1)
    if IsPedInAnyVehicle(entity, false) then
        entity = GetVehiclePedIsUsing(entity)
    end
    SetEntityCoords(entity, x, y, z)
end) 

RegisterNetEvent('ZyoCore:Command:SpawnVehicle')
AddEventHandler('ZyoCore:Command:SpawnVehicle', function(model)
	ZyoCore.Functions.SpawnVehicle(model, function(vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
		TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
	end)
end)

RegisterNetEvent('ZyoCore:Command:DeleteVehicle')
AddEventHandler('ZyoCore:Command:DeleteVehicle', function()
	local vehicle = ZyoCore.Functions.GetClosestVehicle()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) else vehicle = ZyoCore.Functions.GetClosestVehicle() end
	-- TriggerServerEvent('ZyoCore:Command:CheckOwnedVehicle', GetVehicleNumberPlateText(vehicle))
	ZyoCore.Functions.DeleteVehicle(vehicle)
end)

RegisterNetEvent('ZyoCore:Command:Revive')
AddEventHandler('ZyoCore:Command:Revive', function()
	local coords = ZyoCore.Functions.GetCoords(GetPlayerPed(-1))
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
end)

RegisterNetEvent('ZyoCore:Command:GoToMarker')
AddEventHandler('ZyoCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			--HideLoadingPromt()
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('ZyoCore:Player:SetPlayerData')
AddEventHandler('ZyoCore:Player:SetPlayerData', function(val)
	ZyoCore.PlayerData = val
end)

RegisterNetEvent('ZyoCore:Player:UpdatePlayerData')
AddEventHandler('ZyoCore:Player:UpdatePlayerData', function()
	local data = {}
	data.position = ZyoCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('ZyoCore:UpdatePlayer', data)
end)

RegisterNetEvent('ZyoCore:Player:UpdatePlayerPosition')
AddEventHandler('ZyoCore:Player:UpdatePlayerPosition', function()
	local position = ZyoCore.Functions.GetCoords(GetPlayerPed(-1))
	TriggerServerEvent('ZyoCore:UpdatePlayerPosition', position)
end)

RegisterNetEvent('ZyoCore:Client:LocalOutOfCharacter')
AddEventHandler('ZyoCore:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
		TriggerEvent("chatMessage", "OOC " .. playerName, "normal", message)
    end
end)

RegisterNetEvent('ZyoCore:Notify')
AddEventHandler('ZyoCore:Notify', function(text, type, length)
	ZyoCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('ZyoCore:Client:TriggerCallback')
AddEventHandler('ZyoCore:Client:TriggerCallback', function(name, ...)
	if ZyoCore.ServerCallbacks[name] ~= nil then
		ZyoCore.ServerCallbacks[name](...)
		ZyoCore.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent("ZyoCore:Client:UseItem")
AddEventHandler('ZyoCore:Client:UseItem', function(item)
	TriggerServerEvent("ZyoCore:Server:UseItem", item)
end)