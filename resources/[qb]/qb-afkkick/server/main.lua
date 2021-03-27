ZyoCore = nil

TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

RegisterServerEvent("KickForAFK")
AddEventHandler("KickForAFK", function()
	DropPlayer(source, "Foste kick por estar AFK.")
end)

ZyoCore.Functions.CreateCallback('qb-afkkick:server:GetPermissions', function(source, cb)
    local group = ZyoCore.Functions.GetPermission(source)
    cb(group)
end)