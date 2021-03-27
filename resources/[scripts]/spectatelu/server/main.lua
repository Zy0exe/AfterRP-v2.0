ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)



ZyoCore.Commands.Add("spec", "emm1", {}, false, function(source, args)
	TriggerClientEvent('spectatelu:spectate', source, target)
end, "admin")

ZyoCore.Functions.CreateCallback('spectatelu:getPlayerData', function(source, cb, id)
    local Player = ZyoCore.Functions.GetPlayers()
    if Player ~= nil then
        cb(Player)
    end
end)






