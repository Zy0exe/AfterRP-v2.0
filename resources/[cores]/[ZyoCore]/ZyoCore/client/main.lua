ZyoCore = {}
ZyoCore.PlayerData = {}
ZyoCore.Config = QBConfig
ZyoCore.Shared = QBShared
ZyoCore.ServerCallbacks = {}

isLoggedIn = false

function GetCoreObject()
	return ZyoCore
end

RegisterNetEvent('ZyoCore:GetObject')
AddEventHandler('ZyoCore:GetObject', function(cb)
	cb(GetCoreObject())
end)

RegisterNetEvent('ZyoCore:Client:OnPlayerLoaded')
AddEventHandler('ZyoCore:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	isLoggedIn = true
end)

RegisterNetEvent('ZyoCore:Client:OnPlayerUnload')
AddEventHandler('ZyoCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)
