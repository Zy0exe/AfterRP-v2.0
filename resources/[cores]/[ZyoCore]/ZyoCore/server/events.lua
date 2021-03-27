-- Player joined
RegisterServerEvent("ZyoCore:PlayerJoined")
AddEventHandler('ZyoCore:PlayerJoined', function()
	local src = source
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	print("Dropped: "..GetPlayerName(src))
	TriggerEvent("qb-log:server:CreateLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..GetPlayerIdentifiers(src)[1]..") left..")
	TriggerEvent("qb-log:server:sendLog", GetPlayerIdentifiers(src)[1], "joined", {})
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (ZyoCore.Players[src] == nil)) then return false end
	ZyoCore.Players[src].Functions.Save()
	ZyoCore.Players[src] = nil
end)

-- Checking everything before joining
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
	deferrals.update("\nChecking name...")
	local name = GetPlayerName(src)
	if name == nil then 
		ZyoCore.Functions.Kick(src, 'Não use um nome de usuário Steam em branco.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if(string.match(name, "[*%%'=`\"]")) then
        ZyoCore.Functions.Kick(src, 'Você tem um caractere no seu nome de usuário ('..string.match(name, "[*%%'=`\"]")..') that is not allowed.\nPlease remove this out of your Steam username.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database")) then
        ZyoCore.Functions.Kick(src, 'Seu nome de usuário contém uma palavra (drop / table / database) que não é permitida. Por favor, mude seu nome de usuário Steam.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	deferrals.update("\nChecking identifiers...")
    local identifiers = GetPlayerIdentifiers(src)
	local steamid = identifiers[1]
	local license = identifiers[2]
    if (QBConfig.IdentifierType == "steam" and (steamid:sub(1,6) == "steam:") == false) then
        ZyoCore.Functions.Kick(src, 'Você precisa abrir o Steam para jogar.', setKickReason, deferrals)
        CancelEvent()
		return false
	elseif (QBConfig.IdentifierType == "license" and (steamid:sub(1,6) == "license:") == false) then
		ZyoCore.Functions.Kick(src, 'Nenhuma licença do Social Club encontrada.', setKickReason, deferrals)
        CancelEvent()
		return false
    end
	deferrals.update("\nChecking ban status...")
    local isBanned, Reason = ZyoCore.Functions.IsPlayerBanned(src)
    if(isBanned) then
        ZyoCore.Functions.Kick(src, Reason, setKickReason, deferrals)
        CancelEvent()
        return false
    end
	deferrals.update("\nChecking whitelist status...")
    if(not ZyoCore.Functions.IsWhitelisted(src)) then
        ZyoCore.Functions.Kick(src, 'Você não está na lista de permissões.', setKickReason, deferrals)
        CancelEvent()
        return false
    end
	deferrals.update("\nChecking server status...")
    if(ZyoCore.Config.Server.closed and not IsPlayerAceAllowed(src, "qbadmin.join")) then
		ZyoCore.Functions.Kick(_source, 'o servidor está fechado:\n'..ZyoCore.Config.Server.closedReason, setKickReason, deferrals)
        CancelEvent()
        return false
	end
	TriggerEvent("qb-log:server:CreateLog", "joinleave", "Queue", "orange", "**"..name .. "** ("..json.encode(GetPlayerIdentifiers(src))..") in queue..")
	TriggerEvent("qb-log:server:sendLog", GetPlayerIdentifiers(src)[1], "left", {})
	TriggerEvent("connectqueue:playerConnect", src, setKickReason, deferrals)
end)

RegisterServerEvent("ZyoCore:server:CloseServer")
AddEventHandler('ZyoCore:server:CloseServer', function(reason)
    local src = source
    local Player = ZyoCore.Functions.GetPlayer(src)

    if ZyoCore.Functions.HasPermission(source, "admin") or ZyoCore.Functions.HasPermission(source, "god") then 
        local reason = reason ~= nil and reason or "Nenhum motivo especificado..."
        ZyoCore.Config.Server.closed = true
        ZyoCore.Config.Server.closedReason = reason
        TriggerClientEvent("qbadmin:client:SetServerStatus", -1, true)
	else
		ZyoCore.Functions.Kick(src, "Você não tem permissão para isso..", nil, nil)
    end
end)

RegisterServerEvent("ZyoCore:server:OpenServer")
AddEventHandler('ZyoCore:server:OpenServer', function()
    local src = source
    local Player = ZyoCore.Functions.GetPlayer(src)
    if ZyoCore.Functions.HasPermission(source, "admin") or ZyoCore.Functions.HasPermission(source, "god") then
        ZyoCore.Config.Server.closed = false
        TriggerClientEvent("qbadmin:client:SetServerStatus", -1, false)
    else
        ZyoCore.Functions.Kick(src, "Você não tem permissão para isso..", nil, nil)
    end
end)

RegisterServerEvent("ZyoCore:UpdatePlayer")
AddEventHandler('ZyoCore:UpdatePlayer', function(data)
	local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	
	if Player ~= nil then
		Player.PlayerData.position = data.position

		local newHunger = Player.PlayerData.metadata["hunger"] - 4.2
		local newThirst = Player.PlayerData.metadata["thirst"] - 3.8
		if newHunger <= 0 then newHunger = 0 end
		if newThirst <= 0 then newThirst = 0 end
		Player.Functions.SetMetaData("thirst", newThirst)
		Player.Functions.SetMetaData("hunger", newHunger)

		Player.Functions.AddMoney("bank", Player.PlayerData.job.payment)
		TriggerClientEvent('ZyoCore:Notify', src, "Você recebeu seu salario de pagamento de €"..Player.PlayerData.job.payment)
		TriggerClientEvent("hud:client:UpdateNeeds", src, newHunger, newThirst)

		Player.Functions.Save()
	end
end)

RegisterServerEvent("ZyoCore:UpdatePlayerPosition")
AddEventHandler("ZyoCore:UpdatePlayerPosition", function(position)
	local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent("ZyoCore:Server:TriggerCallback")
AddEventHandler('ZyoCore:Server:TriggerCallback', function(name, ...)
	local src = source
	ZyoCore.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("ZyoCore:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("ZyoCore:Server:UseItem")
AddEventHandler('ZyoCore:Server:UseItem', function(item)
	local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	if item ~= nil and item.amount > 0 then
		if ZyoCore.Functions.CanUseItem(item.name) then
			ZyoCore.Functions.UseItem(src, item)
		end
	end
end)

RegisterServerEvent("ZyoCore:Server:RemoveItem")
AddEventHandler('ZyoCore:Server:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(itemName, amount, slot)
end)

RegisterServerEvent("ZyoCore:Server:AddItem")
AddEventHandler('ZyoCore:Server:AddItem', function(itemName, amount, slot, info)
	local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	Player.Functions.AddItem(itemName, amount, slot, info)
end)

RegisterServerEvent('ZyoCore:Server:SetMetaData')
AddEventHandler('ZyoCore:Server:SetMetaData', function(meta, data)
    local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	if meta == "hunger" or meta == "thirst" then
		if data > 100 then
			data = 100
		end
	end
	if Player ~= nil then 
		Player.Functions.SetMetaData(meta, data)
	end
	TriggerClientEvent("hud:client:UpdateNeeds", src, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = ZyoCore.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if ZyoCore.Commands.List[command] ~= nil then
			local Player = ZyoCore.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (ZyoCore.Functions.HasPermission(source, "god") or ZyoCore.Functions.HasPermission(source, ZyoCore.Commands.List[command].permission)) then
					if (ZyoCore.Commands.List[command].argsrequired and #ZyoCore.Commands.List[command].arguments ~= 0 and args[#ZyoCore.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "All arguments must be filled out!")
					    local agus = ""
					    for name, help in pairs(ZyoCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						ZyoCore.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Sem acesso a este comando!")
				end
			end
		end
	end
end)

RegisterServerEvent('ZyoCore:CallCommand')
AddEventHandler('ZyoCore:CallCommand', function(command, args)
	if ZyoCore.Commands.List[command] ~= nil then
		local Player = ZyoCore.Functions.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (ZyoCore.Functions.HasPermission(source, "god")) or (ZyoCore.Functions.HasPermission(source, ZyoCore.Commands.List[command].permission)) or (ZyoCore.Commands.List[command].permission == Player.PlayerData.job.name) then
				if (ZyoCore.Commands.List[command].argsrequired and #ZyoCore.Commands.List[command].arguments ~= 0 and args[#ZyoCore.Commands.List[command].arguments] == nil) then
					TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Todos os argumentos devem ser preenchidos!")
					local agus = ""
					for name, help in pairs(ZyoCore.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					ZyoCore.Commands.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Sem acesso a este comando!")
			end
		end
	end
end)

RegisterServerEvent("ZyoCore:AddCommand")
AddEventHandler('ZyoCore:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	ZyoCore.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("ZyoCore:ToggleDuty")
AddEventHandler('ZyoCore:ToggleDuty', function()
	local src = source
	local Player = ZyoCore.Functions.GetPlayer(src)
	if Player.PlayerData.job.onduty then
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('ZyoCore:Notify', src, "Você agora está fora de serviço!")
	else
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('ZyoCore:Notify', src, "Você agora está a trabalhar!")
	end
	TriggerClientEvent("ZyoCore:Client:SetDuty", src, Player.PlayerData.job.onduty)
end)

Citizen.CreateThread(function()
	ZyoCore.Functions.ExecuteSql(true, "SELECT * FROM `permissions`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				ZyoCore.Config.Server.PermissionList[v.steam] = {
					steam = v.steam,
					license = v.license,
					permission = v.permission,
					optin = true,
				}
			end
		end
	end)
end)

ZyoCore.Functions.CreateCallback('ZyoCore:HasItem', function(source, cb, itemName)
	local retval = false
	local Player = ZyoCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		if Player.Functions.GetItemByName(itemName) ~= nil then
			retval = true
		end
	end
	
	cb(retval)
end)	

RegisterServerEvent('ZyoCore:Command:CheckOwnedVehicle')
AddEventHandler('ZyoCore:Command:CheckOwnedVehicle', function(VehiclePlate)
	if VehiclePlate ~= nil then
		ZyoCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..VehiclePlate.."'", function(result)
			if result[1] ~= nil then
				ZyoCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `state` = '1' WHERE `citizenid` = '"..result[1].citizenid.."'")
				TriggerEvent('qb-garages:server:RemoveVehicle', result[1].citizenid, VehiclePlate)
			end
		end)
	end
end)