ZyoCore.Commands = {}
ZyoCore.Commands.List = {}

ZyoCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	ZyoCore.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

ZyoCore.Commands.Refresh = function(source)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(ZyoCore.Commands.List) do
			if ZyoCore.Functions.HasPermission(source, "god") or ZyoCore.Functions.HasPermission(source, ZyoCore.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

ZyoCore.Commands.Add("tp", "Teleport to a player or location", {{name="id/x", help="ID of a player or X position"}, {name="y", help="Y position"}, {name="z", help="Z position"}}, false, function(source, args)
    if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
        -- tp to player
        local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
        if Player ~= nil then
            TriggerClientEvent('ZyoCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
        end
    else
        -- tp to location
        if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
            local x = tonumber(args[1])
            local y = tonumber(args[2])
            local z = tonumber(args[3])
            TriggerClientEvent('ZyoCore:Command:TeleportToCoords', source, x, y, z)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Not every argument is filled in (x, y, z)")
        end
    end
end, "admin") 

ZyoCore.Commands.Add("darperms", "Conceda permiss??es a algu??m (god/admin)", {{name="id", help="ID of player"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		ZyoCore.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "O jogador n??o est?? online!")	
	end
end, "god")

ZyoCore.Commands.Add("tirarperms", "Remover permiss??es de algu??m", {{name="id", help="ID of player"}}, true, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		ZyoCore.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "O jogador n??o est?? online|")	
	end
end, "god")

ZyoCore.Commands.Add("car", "Spawn a um carro", {{name="model", help="Modelo do carro"}}, true, function(source, args)
	TriggerClientEvent('ZyoCore:Command:SpawnVehicle', source, args[1])
end, "admin")

ZyoCore.Commands.Add("debug", "Ativar / desativar o modo de depura????o", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

ZyoCore.Commands.Add("dv", "Despawn a vehicle", {}, false, function(source, args)
	TriggerClientEvent('ZyoCore:Command:DeleteVehicle', source)
end, "admin")

ZyoCore.Commands.Add("tpm", "Teleporte para o seu waypoint", {}, false, function(source, args)
	TriggerClientEvent('ZyoCore:Command:GoToMarker', source)
end, "admin")

ZyoCore.Commands.Add("givemoney", "D?? dinheiro a um jogador", {{name="id", help="Player ID"},{name="moneytype", help="Type of money (cash, bank, crypto)"}, {name="amount", help="Amount of money"}}, true, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "O jogador n??o est?? online!")
	end
end, "admin")

ZyoCore.Commands.Add("setmoney", "set a players money amount", {{name="id", help="Player ID"},{name="moneytype", help="Type of money (cash, bank, crypto)"}, {name="amount", help="Amount of money"}}, true, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

ZyoCore.Commands.Add("setjob", "Assign a job to a player", {{name="id", help="Speler ID"}, {name="job", help="Job name"}}, true, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetJob(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

ZyoCore.Commands.Add("trabalho", "Veja que trabalho voc?? tem", {}, false, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(source)
	TriggerClientEvent('chatMessage', source, "SITEMA", "warning", "Trabalho: "..Player.PlayerData.job.label)
end)

ZyoCore.Commands.Add("setgang", "Atribuir um jogador a uma gangue", {{name="id", help="Player ID"}, {name="job", help="Name of a gang"}}, true, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetGang(tostring(args[2]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

ZyoCore.Commands.Add("gang", "Veja em qual gangue voc?? est??", {}, false, function(source, args)
	local Player = ZyoCore.Functions.GetPlayer(source)

	if Player.PlayerData.gang.name ~= "geen" then
		TriggerClientEvent('chatMessage', source, "SISTEMA", "warning", "Gang: "..Player.PlayerData.gang.label)
	else
		TriggerClientEvent('ZyoCore:Notify', source, "Voc?? n??o est?? em uma gangue!", "error")
	end
end)

ZyoCore.Commands.Add("testnotify", "test notify", {{name="text", help="Tekst enzo"}}, true, function(source, args)
	TriggerClientEvent('ZyoCore:Notify', source, table.concat(args, " "), "success")
end, "god")

ZyoCore.Commands.Add("clearinv", "Limpe o invent??rio de um jogador", {{name="id", help="Player ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = ZyoCore.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online!")
	end
end, "admin")

ZyoCore.Commands.Add("ooc", "Mensagem fora do personagem", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("ZyoCore:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = ZyoCore.Functions.GetPlayers()
	local Player = ZyoCore.Functions.GetPlayer(source)

	for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
		if ZyoCore.Functions.HasPermission(v, "admin") then
			if ZyoCore.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC " .. GetPlayerName(source), "normal", message)
				TriggerEvent("qb-log:server:CreateLog", "ooc", "OOC", "white", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Message:** " ..message, false)
			end
		end
	end
end)