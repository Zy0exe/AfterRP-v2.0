ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

ZyoCore.Commands.Add("testrepair", "Testar o script", {}, false, function(source, args)
	local _player = ZyoCore.Functions.GetPlayer(source)
	if _player.PlayerData.job.name == "mechanic" then 
	TriggerClientEvent('ft-repair:client:triggerMenu', source)
	end
end)