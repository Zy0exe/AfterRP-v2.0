-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 1800

-- Load ZyoCore
ZyoCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if ZyoCore == nil then
            TriggerEvent("ZyoCore:GetObject", function(obj) ZyoCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local group = "user"
local isLoggedIn = false

RegisterNetEvent('ZyoCore:Client:OnPlayerLoaded')
AddEventHandler('ZyoCore:Client:OnPlayerLoaded', function()
    ZyoCore.Functions.TriggerCallback('qb-afkkick:server:GetPermissions', function(UserGroup)
        group = UserGroup
    end)
    isLoggedIn = true
end)

RegisterNetEvent('ZyoCore:Client:OnPermissionUpdate')
AddEventHandler('ZyoCore:Client:OnPermissionUpdate', function(UserGroup)
    group = UserGroup
end)

-- Code
Citizen.CreateThread(function()
	while true do
		Wait(1000)
        playerPed = GetPlayerPed(-1)
        if isLoggedIn then
            if group == "user" then
                currentPos = GetEntityCoords(playerPed, true)
                if prevPos ~= nil then
                    if currentPos == prevPos then
                        if time ~= nil then
                            if time > 0 then
                                if time == (900) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. math.ceil(time / 60) .. ' minutos !', 'error', 10000)
                                elseif time == (600) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. math.ceil(time / 60) .. ' minutos !', 'error', 10000)
                                elseif time == (300) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. math.ceil(time / 60) .. ' minutos!', 'error', 10000)
                                elseif time == (150) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. math.ceil(time / 60) .. ' minutos!', 'error', 10000)   
                                elseif time == (60) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. math.ceil(time / 60) .. ' minutos!', 'error', 10000) 
                                elseif time == (30) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. time .. ' segundos!', 'error', 10000)  
                                elseif time == (20) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. time .. ' segundos!', 'error', 10000)    
                                elseif time == (10) then
                                    ZyoCore.Functions.Notify('Estas AFK, vais ser kickado dentro de ' .. time .. ' segundos!', 'error', 10000)                                                                                                             
                                end
                                time = time - 1
                            else
                                TriggerServerEvent("KickForAFK")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)