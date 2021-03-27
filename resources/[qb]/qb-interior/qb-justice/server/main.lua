ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

ZyoCore.Commands.Add("setlawyer", "Set someone as a lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = ZyoCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
            OtherPlayer.Functions.SetJob("lawyer")
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("ZyoCore:Notify", source, "Você foi " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. " Contratado como advogado")
            TriggerClientEvent("ZyoCore:Notify", OtherPlayer.PlayerData.source, "Agora você é advogado")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, ZyoCore.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("ZyoCore:Notify", source, "Esta pessoa não está presente.", "error")
        end
    else
        TriggerClientEvent("ZyoCore:Notify", source, "Você não tem direitos ...", "error")
    end
end)

ZyoCore.Commands.Add("removelawyer", "Excluir alguém do advogado", {{name="id", help="id player"}}, true, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = ZyoCore.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "judge" then
        if OtherPlayer ~= nil then 
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("ZyoCore:Notify", OtherPlayer.PlayerData.source, "Você agora está desempregado")
            TriggerClientEvent("ZyoCore:Notify", source, "Você foi ".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname .. "Despedido como advogado")
        else
            TriggerClientEvent("ZyoCore:Notify", source, "Esta pessoa não está presente..", "error")
        end
    else
        TriggerClientEvent("ZyoCore:Notify", source, "Você não tem direitos..", "error")
    end
end)

ZyoCore.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("qb-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)