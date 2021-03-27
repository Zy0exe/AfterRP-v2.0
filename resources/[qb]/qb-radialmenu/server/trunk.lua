ZyoCore = nil
TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

-- Code

local trunkBusy = {}

RegisterServerEvent('qb-trunk:server:setTrunkBusy')
AddEventHandler('qb-trunk:server:setTrunkBusy', function(plate, busy)
    trunkBusy[plate] = busy
end)

ZyoCore.Functions.CreateCallback('qb-trunk:server:getTrunkBusy', function(source, cb, plate)
    if trunkBusy[plate] then
        cb(true)
    end
    cb(false)
end)

RegisterServerEvent('qb-trunk:server:KidnapTrunk')
AddEventHandler('qb-trunk:server:KidnapTrunk', function(targetId, closestVehicle)
    TriggerClientEvent('qb-trunk:client:KidnapGetIn', targetId, closestVehicle)
end)

ZyoCore.Commands.Add("getintrunk", "Entre no porta-malas", {}, false, function(source, args)
    TriggerClientEvent('qb-trunk:client:GetIn', source)
end)

ZyoCore.Commands.Add("kidnaptrunk", "Entre no porta-malas", {}, false, function(source, args)
    TriggerClientEvent('qb-trunk:server:KidnapTrunk', source)
end)