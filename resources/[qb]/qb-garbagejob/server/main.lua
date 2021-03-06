ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

local Bail = {}

ZyoCore.Functions.CreateCallback('qb-garbagejob:server:HasMoney', function(source, cb)
    local Player = ZyoCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= Config.BailPrice then
        Bail[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', Config.BailPrice)
        cb(true)
    elseif Player.PlayerData.money.bank >= Config.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)

ZyoCore.Functions.CreateCallback('qb-garbagejob:server:CheckBail', function(source, cb)
    local Player = ZyoCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Config.BailPrice)
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)

local Materials = {
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

RegisterServerEvent('qb-garbagejob:server:PayShit')
AddEventHandler('qb-garbagejob:server:PayShit', function(amount, location)
    local src = source
    local Player = ZyoCore.Functions.GetPlayer(src)

    if amount > 0 then
        Player.Functions.AddMoney('bank', amount)

        if location == #Config.Locations["vuilnisbakken"] then
            for i = 1, math.random(3, 5), 1 do
                local item = Materials[math.random(1, #Materials)]
                Player.Functions.AddItem(item, math.random(40, 70))
                TriggerClientEvent('inventory:client:ItemBox', src, ZyoCore.Shared.Items[item], 'add')
                Citizen.Wait(500)
            end
        end

        TriggerClientEvent('ZyoCore:Notify', src, "Você foi pago €"..amount..",- do seu Banco", "success")
    else
        TriggerClientEvent('ZyoCore:Notify', src, "Você não pagou nada..", "error")
    end
end)