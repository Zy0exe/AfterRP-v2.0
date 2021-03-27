ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

local ItemList = {
    ["casinochips"] = 1,
}

RegisterServerEvent("qb-casino:sharlock:sell")
AddEventHandler("qb-casino:sharlock:sell", function()
    local src = source
    local price = 0
    local Player = ZyoCore.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] ~= nil then 
                if ItemList[Player.PlayerData.items[k].name] ~= nil then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-casino-chips")
        TriggerClientEvent('ZyoCore:Notify', src, "Você vendeu suas fichas")
        TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "blue", "**"..GetPlayerName(src) .. "** got $"..price.." for selling the Chips")
        else
        TriggerClientEvent('ZyoCore:Notify', src, "Você não tem fichas..")
    end
end)

function SetExports()
exports["qb-blackjack"]:SetGetChipsCallback(function(source)
    local Player = ZyoCore.Functions.GetPlayer(source)
    local Chips = Player.Functions.GetItemByName("casinochips")

    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then 
        Chips = Chips
    end

    return TriggerClientEvent('ZyoCore:Notify', src, "Você não tem fichas..")
end)

    exports["qb-blackjack"]:SetTakeChipsCallback(function(source, amount)
        local Player = ZyoCore.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.RemoveItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, ZyoCore.Shared.Items['casinochips'], "remove")
            TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "yellow", "**"..GetPlayerName(source) .. "** put $"..amount.." in table")
        end
    end)

    exports["qb-blackjack"]:SetGiveChipsCallback(function(source, amount)
        local Player = ZyoCore.Functions.GetPlayer(source)

        if Player ~= nil then
            Player.Functions.AddItem("casinochips", amount)
            TriggerClientEvent('inventory:client:ItemBox', source, ZyoCore.Shared.Items['casinochips'], "add")
            TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "red", "**"..GetPlayerName(source) .. "** got $"..amount.." from table table and he won the double")
        end
    end)
end

AddEventHandler("onResourceStart", function(resourceName)
	if ("qb-blackjack" == resourceName) then
        Citizen.Wait(1000)
        SetExports()
    end
end)

SetExports()
