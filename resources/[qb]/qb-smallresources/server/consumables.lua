ZyoCore.Functions.CreateUseableItem("joint", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseJoint", source)
    end
end)

ZyoCore.Functions.CreateUseableItem("armor", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseArmor", source)
end)

ZyoCore.Functions.CreateUseableItem("heavyarmor", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:UseHeavyArmor", source)
end)

-- ZyoCore.Functions.CreateUseableItem("smoketrailred", function(source, item)
--     local Player = ZyoCore.Functions.GetPlayer(source)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("consumables:client:UseRedSmoke", source)
--     end
-- end)

ZyoCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:UseParachute", source)
    end
end)

ZyoCore.Commands.Add("parachuteuit", "Doe je parachute uit", {}, false, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
        TriggerClientEvent("consumables:client:ResetParachute", source)
end)

RegisterServerEvent("qb-smallpenis:server:AddParachute")
AddEventHandler("qb-smallpenis:server:AddParachute", function()
    local src = source
    local Ply = ZyoCore.Functions.GetPlayer(src)

    Ply.Functions.AddItem("parachute", 1)
end)

ZyoCore.Functions.CreateUseableItem("water_bottle", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("vodka", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

ZyoCore.Functions.CreateUseableItem("beer", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

ZyoCore.Functions.CreateUseableItem("whiskey", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)

ZyoCore.Functions.CreateUseableItem("coffee", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("kurkakola", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("sandwich", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("twerks_candy", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("snikkel_candy", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("tosti", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", source, item.name)
    end
end)

ZyoCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

ZyoCore.Functions.CreateUseableItem("cokebaggy", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Cokebaggy", source)
end)

ZyoCore.Functions.CreateUseableItem("crack_baggy", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:Crackbaggy", source)
end)

ZyoCore.Functions.CreateUseableItem("xtcbaggy", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("consumables:client:EcstasyBaggy", source)
end)

ZyoCore.Functions.CreateUseableItem("firework1", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework")
end)

ZyoCore.Functions.CreateUseableItem("radio", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
	--TriggerClientEvent('Radio.Set', source, true)
    TriggerClientEvent('Radio.Toggle', source)
    --TriggerClientEvent('coderadio:use', source)
end)

ZyoCore.Functions.CreateUseableItem("firework2", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_indep_firework_v2")
end)

ZyoCore.Functions.CreateUseableItem("firework3", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "proj_xmas_firework")
end)

ZyoCore.Functions.CreateUseableItem("firework4", function(source, item)
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent("fireworks:client:UseFirework", source, item.name, "scr_indep_fireworks")
end)

ZyoCore.Commands.Add("vestuit", "Tire seu colete da cabeça", {}, false, function(source, args)
    local Player = ZyoCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("consumables:client:ResetArmor", source)
    else
        TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "Este comando é para serviços de emergência!")
    end
end)