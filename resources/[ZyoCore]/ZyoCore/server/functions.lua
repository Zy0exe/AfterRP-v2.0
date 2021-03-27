ZyoCore.Functions = {}

ZyoCore.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['ghmattimysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

ZyoCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or QBConfig.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

ZyoCore.Functions.GetSource = function(identifier)
	for src, player in pairs(ZyoCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

ZyoCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return ZyoCore.Players[source]
	else
		return ZyoCore.Players[ZyoCore.Functions.GetSource(source)]
	end
end

ZyoCore.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(ZyoCore.Players) do
		local cid = citizenid
		if ZyoCore.Players[src].PlayerData.citizenid == cid then
			return ZyoCore.Players[src]
		end
	end
	return nil
end

ZyoCore.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(ZyoCore.Players) do
		local cid = citizenid
		if ZyoCore.Players[src].PlayerData.charinfo.phone == number then
			return ZyoCore.Players[src]
		end
	end
	return nil
end

ZyoCore.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(ZyoCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

ZyoCore.Functions.CreateCallback = function(name, cb)
	ZyoCore.ServerCallbacks[name] = cb
end

ZyoCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if ZyoCore.ServerCallbacks[name] ~= nil then
		ZyoCore.ServerCallbacks[name](source, cb, ...)
	end
end

ZyoCore.Functions.CreateUseableItem = function(item, cb)
	ZyoCore.UseableItems[item] = cb
end

ZyoCore.Functions.CanUseItem = function(item)
	return ZyoCore.UseableItems[item] ~= nil
end

ZyoCore.Functions.UseItem = function(source, item)
	ZyoCore.UseableItems[item.name](source, item)
end

ZyoCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Verifique nosso Discord para mais informações: "..ZyoCore.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

ZyoCore.Functions.IsWhitelisted = function(source)
	local identifiers = GetPlayerIdentifiers(source)
	local rtn = false
	if (ZyoCore.Config.Server.whitelist) then
		ZyoCore.Functions.ExecuteSql(true, "SELECT * FROM `whitelist` WHERE `"..ZyoCore.Config.IdentifierType.."` = '".. ZyoCore.Functions.GetIdentifier(source).."'", function(result)
			local data = result[1]
			if data ~= nil then
				for _, id in pairs(identifiers) do
					if data.steam == id or data.license == id then
						rtn = true
					end
				end
			end
		end)
	else
		rtn = true
	end
	return rtn
end

ZyoCore.Functions.AddPermission = function(source, permission)
	local Player = ZyoCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		ZyoCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		ZyoCore.Functions.ExecuteSql(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		ZyoCore.Functions.ExecuteSql(true, "INSERT INTO `permissions` (`name`, `steam`, `license`, `permission`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..permission:lower().."')")
		Player.Functions.UpdatePlayerData()
		TriggerClientEvent('ZyoCore:Client:OnPermissionUpdate', source, permission)
	end
end

ZyoCore.Functions.RemovePermission = function(source)
	local Player = ZyoCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		ZyoCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = nil	
		ZyoCore.Functions.ExecuteSql(true, "DELETE FROM `permissions` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

ZyoCore.Functions.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if ZyoCore.Config.Server.PermissionList[steamid] ~= nil then 
			if ZyoCore.Config.Server.PermissionList[steamid].steam == steamid and ZyoCore.Config.Server.PermissionList[steamid].license == licenseid then
				if ZyoCore.Config.Server.PermissionList[steamid].permission == permission or ZyoCore.Config.Server.PermissionList[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

ZyoCore.Functions.GetPermission = function(source)
	local retval = "user"
	Player = ZyoCore.Functions.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if ZyoCore.Config.Server.PermissionList[Player.PlayerData.steam] ~= nil then 
			if ZyoCore.Config.Server.PermissionList[Player.PlayerData.steam].steam == steamid and ZyoCore.Config.Server.PermissionList[Player.PlayerData.steam].license == licenseid then
				retval = ZyoCore.Config.Server.PermissionList[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

ZyoCore.Functions.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if ZyoCore.Functions.HasPermission(source, "admin") then
		retval = ZyoCore.Config.Server.PermissionList[steamid].optin
	end
	return retval
end

ZyoCore.Functions.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if ZyoCore.Functions.HasPermission(source, "admin") then
		ZyoCore.Config.Server.PermissionList[steamid].optin = not ZyoCore.Config.Server.PermissionList[steamid].optin
	end
end

ZyoCore.Functions.IsPlayerBanned = function (source)
	local retval = false
	local message = ""
	ZyoCore.Functions.ExecuteSql(true, "SELECT * FROM `bans` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."' OR `license` = '"..GetPlayerIdentifiers(source)[2].."' OR `ip` = '"..GetPlayerIdentifiers(source)[3].."'", function(result)
		if result[1] ~= nil then 
			if os.time() < result[1].expire then
				retval = true
				local timeTable = os.date("*t", tonumber(result[1].expire))
				message = "Você foi banido do servidor:\n"..result[1].reason.."\nFalta : "..timeTable.day.. "/" .. timeTable.month .. "/" .. timeTable.year .. " " .. timeTable.hour.. ":" .. timeTable.min .. "\n"
			else
				ZyoCore.Functions.ExecuteSql(true, "DELETE FROM `bans` WHERE `id` = "..result[1].id)
			end
		end
	end)
	return retval, message
end

