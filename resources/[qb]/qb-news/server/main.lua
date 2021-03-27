ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

ZyoCore.Commands.Add("newscam", "Take news camera", {}, false, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

ZyoCore.Commands.Add("newsmic", "Take news microphone", {}, false, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

