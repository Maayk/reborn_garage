RebornCore = nil

TriggerEvent('RebornCore:GetObject', function(obj) RebornCore = obj end)

local OutsideVehicles = {}

-- code

RegisterServerEvent('cash-garagesystem:server:RemoveVehicle')
AddEventHandler('cash-garagesystem:server:RemoveVehicle', function(CitizenId, Plate)
    if OutsideVehicles[CitizenId] ~= nil then
        OutsideVehicles[CitizenId][Plate] = nil
    end
end)

RegisterServerEvent('cash-garagesystem:server:UpdateOutsideVehicles')
AddEventHandler('cash-garagesystem:server:UpdateOutsideVehicles', function(Vehicles)
    local src = source
    local Ply = RebornCore.Functions.GetPlayer(src)
    local CitizenId = Ply.PlayerData.citizenid

    OutsideVehicles[CitizenId] = Vehicles
end)

RebornCore.Functions.CreateCallback("cash-garage:server:GetOutsideVehicles", function(source, cb)
    local Ply = RebornCore.Functions.GetPlayer(source)
    local CitizenId = Ply.PlayerData.citizenid

    if OutsideVehicles[CitizenId] ~= nil and next(OutsideVehicles[CitizenId]) ~= nil then
        cb(OutsideVehicles[CitizenId])
    else
        cb(nil)
    end
end)

RebornCore.Functions.CreateCallback("cash-garage:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = RebornCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND garage = @garage', {['@citizenid'] = pData.PlayerData.citizenid, ['@garage'] = garage}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if v.status ~= nil then
                    v.status = json.decode(v.status)
                end
            end
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RebornCore.Functions.CreateCallback("cash-garage:server:GetVehicleProperties", function(source, cb, plate)
    local src = source
    local properties = {}




    -- RebornCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)

    -- end)

    local result = exports.ghmattimysql:execute('SELECT `mods` FROM player_vehicles WHERE plate=@plate', {['@plate'] = plate})

    if result[1] ~= nil then
        properties = json.decode(result[1].mods)
    end
    cb(properties)

end)

RebornCore.Functions.CreateCallback("cash-garage:server:GetDepotVehicles", function(source, cb)
    local src = source
    local pData = RebornCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE citizenid = @citizenid AND state = @state', {['@citizenid'] = pData.PlayerData.citizenid, ['@state'] = 0}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if v.status ~= nil then
                    v.status = json.decode(v.status)
                end
            end
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RebornCore.Functions.CreateCallback("cash-garage:server:GetHouseVehicles", function(source, cb, house)
    local src = source
    local pData = RebornCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE garage = @garage', {['@garage'] = house}, function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                if v.status ~= nil then
                    v.status = json.decode(v.status)
                end
            end
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RebornCore.Functions.CreateCallback("cash-garage:server:checkVehicleHouseOwner", function(source, cb, plate, house)
    local src = source
    local pData = RebornCore.Functions.GetPlayer(src)
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate', {['@plate'] = plate}, function(result)
        if result[1] ~= nil then
            local hasHouseKey = exports['cash-playerhousing']:hasKey(result[1].steam, result[1].citizenid, house)
            if hasHouseKey then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('Reborn:Deposito:Pagamento')
AddEventHandler('Reborn:Deposito:Pagamento', function(placa, garage)
    local src = source
    local Player = RebornCore.Functions.GetPlayer(src)
    local bankBalance = Player.PlayerData.money["bank"]
    exports['ghmattimysql']:execute('SELECT * FROM player_vehicles WHERE plate = @plate', {['@plate'] = placa}, function(result)
        if result[1] ~= nil then
            if Player.Functions.RemoveMoney("cash", result[1].depotprice, "pagando-deposito") then
                TriggerClientEvent('Reborn:Depot:SpawnCarro',src,placa)
            elseif bankBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("bank", result[1].depotprice, "pagando-deposito")
                TriggerClientEvent('Reborn:Depot:SpawnCarro',src,placa)
            end
        end
    end)
end)

RegisterServerEvent('cash-garage:server:updateVehicleState')
AddEventHandler('cash-garage:server:updateVehicleState', function(state, plate, garage)
    local src = source
    local pData = RebornCore.Functions.GetPlayer(src)

    exports['ghmattimysql']:execute('UPDATE player_vehicles SET state = @state, garage = @garage, depotprice = @depotprice WHERE plate = @plate', {['@state'] = state, ['@plate'] = plate, ['@depotprice'] = 0, ['@citizenid'] = pData.PlayerData.citizenid, ['@garage'] = garage})
    -- print('updated')
end)

RegisterServerEvent('cash-garage:server:updateVehicleStatus')
AddEventHandler('cash-garage:server:updateVehicleStatus', function(fuel, engine, body, plate, garage)
    local src = source
    local pData = RebornCore.Functions.GetPlayer(src)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    exports['ghmattimysql']:execute('UPDATE player_vehicles SET fuel = @fuel, engine = @engine, body = @body WHERE plate = @plate AND citizenid = @citizenid AND garage = @garage', {
        ['@fuel'] = fuel, 
        ['@engine'] = engine, 
        ['@body'] = body,
        ['@plate'] = plate,
        ['@garage'] = garage,
        ['@citizenid'] = pData.PlayerData.citizenid
    })
end)