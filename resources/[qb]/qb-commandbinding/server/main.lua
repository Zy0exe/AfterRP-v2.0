ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

-- Code

ZyoCore.Commands.Add("binds", "Abrir menu de binds", {}, false, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
	TriggerClientEvent("qb-commandbinding:client:openUI", source)
end)

RegisterServerEvent('qb-commandbinding:server:setKeyMeta')
AddEventHandler('qb-commandbinding:server:setKeyMeta', function(keyMeta)
    local src = source
    local ply = ZyoCore.Functions.GetPlayer(src)

    ply.Functions.SetMetaData("commandbinds", keyMeta)
end)