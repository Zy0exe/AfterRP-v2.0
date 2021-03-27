ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

-- Code

ZyoCore.Functions.CreateCallback('qb-scoreboard:server:GetActivity', function(source, cb)
    local PoliceCount = 0
    local AmbulanceCount = 0
    
    for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
        local Player = ZyoCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                PoliceCount = PoliceCount + 1
            end

            if ((Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "doctor") and Player.PlayerData.job.onduty) then
                AmbulanceCount = AmbulanceCount + 1
            end
        end
    end

    cb(PoliceCount, AmbulanceCount)
end)

ZyoCore.Functions.CreateCallback('qb-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

ZyoCore.Functions.CreateCallback('qb-scoreboard:server:GetPlayersArrays', function(source, cb)
    local players = {}
    for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
        local Player = ZyoCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            players[Player.PlayerData.source] = {}
            players[Player.PlayerData.source].permission = ZyoCore.Functions.IsOptin(Player.PlayerData.source)
        end
    end
    cb(players)
end)

RegisterServerEvent('qb-scoreboard:server:SetActivityBusy')
AddEventHandler('qb-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('qb-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)