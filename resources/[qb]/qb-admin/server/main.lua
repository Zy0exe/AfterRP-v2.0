ZyoCore = nil

TriggerEvent('ZyoCore:GetObject', function(obj) ZyoCore = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "god",
    ["managegroup"] = "god"
}

RegisterServerEvent('qb-admin:server:togglePlayerNoclip')
AddEventHandler('qb-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("qb-admin:client:toggleNoclip", playerId)
    end
end)

RegisterServerEvent('qb-admin:server:killPlayer')
AddEventHandler('qb-admin:server:killPlayer', function(playerId)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["kickall"]) then
        TriggerClientEvent('hospital:client:KillPlayer', playerId)
    end
end)

RegisterServerEvent('qb-admin:server:kickPlayer')
AddEventHandler('qb-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "Você foi expulso do servidor:\n"..reason.."\n\n🔸 Junte-se ao nosso Discord para mais informações: https://discord.gg/qGKrJj7NuM")
    end
end)

RegisterServerEvent('qb-admin:server:Freeze')
AddEventHandler('qb-admin:server:Freeze', function(playerId, toggle)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["kickall"]) then
        TriggerClientEvent('qb-admin:client:Freeze', playerId, toggle)
    end
end)

RegisterServerEvent('qb-admin:server:serverKick')
AddEventHandler('qb-admin:server:serverKick', function(reason)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "Você foi expulso do servidor:\n"..reason.."\n\n🔸 Junte-se ao nosso Discord para mais informações: https://discord.gg/qGKrJj7NuM")
            end
        end
    end
end)

local suffix = {
    "hihi",
    "#yolo",
    "hmm slurpie",
    "yeet terug naar esx",
}

RegisterServerEvent('qb-admin:server:banPlayer')
AddEventHandler('qb-admin:server:banPlayer', function(playerId, time, reason)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["ban"]) then
        local time = tonumber(time)
        local banTime = tonumber(os.time() + time)
        if banTime > 2147483647 then
            banTime = 2147483647
        end
        local timeTable = os.date("*t", banTime)
        TriggerClientEvent('chatMessage', -1, "THOR", "error", GetPlayerName(playerId).." foi banido por: "..reason.." "..suffix[math.random(1, #suffix)])
        ZyoCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..GetPlayerIdentifiers(playerId)[3].."', '"..GetPlayerIdentifiers(playerId)[4].."', '"..reason.."', "..banTime..", '"..GetPlayerName(src).."')")
        DropPlayer(playerId, "Você foi banido do servidor:\n"..reason.."\n\nAcaba "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Entre no Discord para mais informações: https://discord.gg/qGKrJj7NuM")
    end
end)
RegisterServerEvent('qb-admin:server:revivePlayer')
AddEventHandler('qb-admin:server:revivePlayer', function(target)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["kickall"]) then
	    TriggerClientEvent('hospital:client:Revive', target)
    end
end)

ZyoCore.Commands.Add("anuciostaff", "Anuncie uma mensagem a todos", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SISTEMA", "error", msg)
    end
end, "admin")

ZyoCore.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = ZyoCore.Functions.GetPermission(source)
    local dealers = exports['qb-drugs']:GetDealers()
    TriggerClientEvent('qb-admin:client:openMenu', source, group, dealers)
end, "admin")

ZyoCore.Commands.Add("report", "Envie um relatório para os administradores (apenas quando necessário, NÃO ABUSE ISSO!)", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")
    local Player = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT Enviado", "normal", msg)
    TriggerEvent("qb-log:server:CreateLog", "report", "Report", "green", "**"..GetPlayerName(source).."** (CitizenID: "..Player.PlayerData.citizenid.." | ID: "..source..") **Report:** " ..msg, false)
    TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

ZyoCore.Commands.Add("staffchat", "Envie uma mensagem a todos os membros da equipe", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

ZyoCore.Commands.Add("givenuifocus", "Give nui focus", {{name="id", help="Player id"}, {name="focus", help="Set focus on/off"}, {name="mouse", help="Set mouse on/off"}}, true, function(source, args)
    local playerid = tonumber(args[1])
    local focus = args[2]
    local mouse = args[3]

    TriggerClientEvent('qb-admin:client:GiveNuiFocus', playerid, focus, mouse)
end, "admin")

ZyoCore.Commands.Add("s", "Envie uma mensagem a todos os membros da equipe", {{name="message", help="Message"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('qb-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

ZyoCore.Commands.Add("avisos", "Avisar um jogador", {{name="ID", help="Jogador"}, {name="Razão", help="Mencione um motivo"}}, true, function(source, args)
    local targetPlayer = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
    local senderPlayer = ZyoCore.Functions.GetPlayer(source)
    table.remove(args, 1)
    local msg = table.concat(args, " ")

    local myName = senderPlayer.PlayerData.name

    local warnId = "AVISO-"..math.random(1111, 9999)

    if targetPlayer ~= nil then
        TriggerClientEvent('chatMessage', targetPlayer.PlayerData.source, "SISTEMA", "error", "Você foi avisado por:: "..GetPlayerName(source)..", Reason: "..msg)
        TriggerClientEvent('chatMessage', source, "SISTEMA", "error", "You have warned "..GetPlayerName(targetPlayer.PlayerData.source).." for: "..msg)
        ZyoCore.Functions.ExecuteSql(false, "INSERT INTO `player_warns` (`senderIdentifier`, `targetIdentifier`, `reason`, `warnId`) VALUES ('"..senderPlayer.PlayerData.steam.."', '"..targetPlayer.PlayerData.steam.."', '"..msg.."', '"..warnId.."')")
    else
        TriggerClientEvent('ZyoCore:Notify', source, 'Este jogador não está online', 'error')
    end 
end, "admin")

ZyoCore.Commands.Add("veravisos", "Ver avisos de staffs para um jogador", {{name="ID", help="Player"}, {name="Warning", help="Número de aviso, (1, 2 or 3 etc..)"}}, false, function(source, args)
    if args[2] == nil then
        local targetPlayer = ZyoCore.Functions.GetPlayer(tonumber(args[1]))
        ZyoCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(result)
            print(json.encode(result))
            TriggerClientEvent('chatMessage', source, "SISTEMA", "warning", targetPlayer.PlayerData.name.." tem "..tablelength(result).." aviso/s!")
        end)
    else
        local targetPlayer = ZyoCore.Functions.GetPlayer(tonumber(args[1]))

        ZyoCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
            local selectedWarning = tonumber(args[2])

            if warnings[selectedWarning] ~= nil then
                local sender = ZyoCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

                TriggerClientEvent('chatMessage', source, "SISTEMA", "warning", targetPlayer.PlayerData.name.." foi avisado por "..sender.PlayerData.name..", Razão: "..warnings[selectedWarning].reason)
            end
        end)
    end
end, "admin")

ZyoCore.Commands.Add("apagaraviso", "Excluir avisos de uma pessoa", {{name="ID", help="Player"}, {name="Warning", help="Número de aviso, (1, 2 or 3 etc..)"}}, true, function(source, args)
    local targetPlayer = ZyoCore.Functions.GetPlayer(tonumber(args[1]))

    ZyoCore.Functions.ExecuteSql(false, "SELECT * FROM `player_warns` WHERE `targetIdentifier` = '"..targetPlayer.PlayerData.steam.."'", function(warnings)
        local selectedWarning = tonumber(args[2])

        if warnings[selectedWarning] ~= nil then
            local sender = ZyoCore.Functions.GetPlayer(warnings[selectedWarning].senderIdentifier)

            TriggerClientEvent('chatMessage', source, "SISTEMA", "warning", "Você excluiu aviso ("..selectedWarning..") , Razão: "..warnings[selectedWarning].reason)
            ZyoCore.Functions.ExecuteSql(false, "DELETE FROM `player_warns` WHERE `warnId` = '"..warnings[selectedWarning].warnId.."'")
        end
    end)
end, "admin")

function tablelength(table)
    local count = 0
    for _ in pairs(table) do 
        count = count + 1 
    end
    return count
end

ZyoCore.Commands.Add("reportr", "Responder a um relatório", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = ZyoCore.Functions.GetPlayer(playerId)
    local Player = ZyoCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "warning", msg)
        TriggerClientEvent('ZyoCore:Notify', source, "Resposta enviada")
        TriggerEvent("qb-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
            if ZyoCore.Functions.HasPermission(v, "admin") then
                if ZyoCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "warning", msg)
                    TriggerEvent("qb-log:server:CreateLog", "report", "Report Reply", "red", "**"..GetPlayerName(source).."** respondeu ao: **"..OtherPlayer.PlayerData.name.. " **(ID: "..OtherPlayer.PlayerData.source..") **Message:** " ..msg, false)
                end
            end
        end
    else
        TriggerClientEvent('ZyoCore:Notify', source, "Não esta online", "error")
    end
end, "admin")

ZyoCore.Commands.Add("setmodel", "Mude para um modelo de que você goste..", {{name="model", help="Name of the model"}, {name="id", help="Id of the Player (empty for yourself)"}}, false, function(source, args)
    local model = args[1]
    local target = tonumber(args[2])

    if model ~= nil or model ~= "" then
        if target == nil then
            TriggerClientEvent('qb-admin:client:SetModel', source, tostring(model))
        else
            local Trgt = ZyoCore.Functions.GetPlayer(target)
            if Trgt ~= nil then
                TriggerClientEvent('qb-admin:client:SetModel', target, tostring(model))
            else
                TriggerClientEvent('ZyoCore:Notify', source, "This person is not online..", "error")
            end
        end
    else
        TriggerClientEvent('ZyoCore:Notify', source, "You did not set a model..", "error")
    end
end, "admin")

ZyoCore.Commands.Add("setspeed", "Change to a speed you like..", {}, false, function(source, args)
    local speed = args[1]

    if speed ~= nil then
        TriggerClientEvent('qb-admin:client:SetSpeed', source, tostring(speed))
    else
        TriggerClientEvent('ZyoCore:Notify', source, "You did not set a speed.. (`fast` for super-run, `normal` for normal)", "error")
    end
end, "admin")


ZyoCore.Commands.Add("admincar", "Guarde o veículo na sua garagem", {}, false, function(source, args)
    local ply = ZyoCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-admin:client:SaveCar', source)
end, "admin")

RegisterServerEvent('qb-admin:server:SaveCar')
AddEventHandler('qb-admin:server:SaveCar', function(mods, vehicle, hash, plate)
    local src = source
    local Player = ZyoCore.Functions.GetPlayer(src)
    ZyoCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] == nil then
            ZyoCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..Player.PlayerData.steam.."', '"..Player.PlayerData.citizenid.."', '"..vehicle.model.."', '"..vehicle.hash.."', '"..json.encode(mods).."', '"..plate.."', 0)")
            TriggerClientEvent('ZyoCore:Notify', src, 'O veículo agora é seu!', 'success', 5000)
        else
            TriggerClientEvent('ZyoCore:Notify', src, 'Este veículo já é seu..', 'error', 3000)
        end
    end)
end)

ZyoCore.Commands.Add("verreports", "Alternar relatórios recebidos", {}, false, function(source, args)
    ZyoCore.Functions.ToggleOptin(source)
    if ZyoCore.Functions.IsOptin(source) then
        TriggerClientEvent('ZyoCore:Notify', source, "Você está recebendo relatórios", "success")
    else
        TriggerClientEvent('ZyoCore:Notify', source, "Você não está recebendo relatórios", "error")
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = ZyoCore.Functions.GetPlayer(src)

        if ZyoCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
                    local Player = ZyoCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SISTEMA', 'error', 'Mencione um motivo..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SISTEMA', 'error', 'Você não pode fazer isso..')
        end
    else
        for k, v in pairs(ZyoCore.Functions.GetPlayers()) do
            local Player = ZyoCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Olá seu lindo - Estamos a reniciar o servidor, Verifique o Discord para mais informações! (https://discord.gg/qGKrJj7NuM)")
            end
        end
    end
end, false)

RegisterServerEvent('qb-admin:server:bringTp')
AddEventHandler('qb-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('qb-admin:client:bringTp', targetId, coords)
end)

ZyoCore.Functions.CreateCallback('qb-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false

    if ZyoCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('qb-admin:server:setPermissions')
AddEventHandler('qb-admin:server:setPermissions', function(targetId, group)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["managegroup"]) then
        ZyoCore.Functions.AddPermission(targetId, group.rank)
        TriggerClientEvent('ZyoCore:Notify', targetId, 'Added Permission '..group.label)
    end
end)

RegisterServerEvent('qb-admin:server:OpenSkinMenu')
AddEventHandler('qb-admin:server:OpenSkinMenu', function(targetId)
    local src = source
    if ZyoCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("qb-clothing:client:openMenu", targetId)
    end
end)

RegisterServerEvent('qb-admin:server:SendReport')
AddEventHandler('qb-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = ZyoCore.Functions.GetPlayers()

    if ZyoCore.Functions.HasPermission(src, "admin") then
        if ZyoCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('qb-admin:server:StaffChatMessage')
AddEventHandler('qb-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = ZyoCore.Functions.GetPlayers()

    if ZyoCore.Functions.HasPermission(src, "admin") then
        if ZyoCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)

ZyoCore.Commands.Add("setammo", "Staff: define munição manual para uma arma.", {{name="amount", help="Amount of bullets, for example: 20"}, {name="weapon", help="Name of the weapen, for example: WEAPON_VINTAGEPISTOL"}}, false, function(source, args)
    local src = source
    local weapon = args[2]
    local amount = tonumber(args[1])

    if weapon ~= nil then
        TriggerClientEvent('qb-weapons:client:SetWeaponAmmoManual', src, weapon, amount)
    else
        TriggerClientEvent('qb-weapons:client:SetWeaponAmmoManual', src, "current", amount)
    end
end, 'admin')