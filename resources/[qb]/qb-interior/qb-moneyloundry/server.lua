-------------------------------------
------- Created by CODERC-SLO -------
-----------Money Loundry---------------
------------------------------------- 
local CoolDownTimerATM = {}
ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)
---######################################################---


---------------------------------------------PROCESS MONEY CLEANING-----------------------
local itname1 = 'black_money'
RegisterServerEvent('pulisci:moneblak')
AddEventHandler('pulisci:moneblak', function()
   
    local _source = source
    local xPlayer = ZyoCore.Functions.GetPlayer(_source)
    local Item = xPlayer.Functions.GetItemByName(itname1)
    
   
    if Item == nil then
        TriggerClientEvent('ZyoCore:Notify', source, 'Não tens dinheiro sujo para lavar, burro do crh :/!', "error", 8000)  
    else
        if Item.amount >= Item.amount then

           ----------------elimino dal mio inventario---------------------------------------------------------
           xPlayer.Functions.RemoveItem(itname1, Item.amount)
           TriggerClientEvent("inventory:client:ItemBox", source, ZyoCore.Shared.Items[itname1], "remove")
		   xPlayer.Functions.AddMoney("cash", Item.amount, "sold-pawn-items")
       
           
        else
            TriggerClientEvent('ZyoCore:Notify', _source, 'Não tens dinheiro sujo para lavar, burro do crh :/!', "error", 10000)  
           
        end
    end

end)
---------------------------------clean end---------------------------------------------------------------