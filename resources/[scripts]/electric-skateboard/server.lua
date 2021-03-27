RegisterServerEvent("shareImOnSkate")
AddEventHandler("shareImOnSkate", function() 
--    print("Shareando!")
    local _source = source
    TriggerClientEvent("shareHeIsOnSkate", -1, _source)
end)

ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)


ZyoCore.Functions.CreateUseableItem("skateboard", function(source, item)
	local Player = ZyoCore.Functions.GetPlayer(source)
	Player.Functions.RemoveItem("skateboard", 1, item.slot) 
	TriggerClientEvent('skateboard:Spawn', source)
	TriggerClientEvent('inventory:client:ItemBox', source, ZyoCore.Shared.Items["skateboard"], "remove")
end)

RegisterServerEvent('skateboard:pick')
AddEventHandler('skateboard:pick', function(item, amount)	
	local Player = ZyoCore.Functions.GetPlayer(source)
	Player.Functions.AddItem("skateboard", 1)
	TriggerClientEvent('inventory:client:ItemBox', source, ZyoCore.Shared.Items["skateboard"], "add")
end)



