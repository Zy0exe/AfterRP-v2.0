ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

ZyoCore.Commands.Add("radar", "Alternar radar de velocidade :)", {}, false, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Este comando é para serviços de emergência!")
    end
end)