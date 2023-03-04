RebornCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if RebornCore == nil then
            TriggerEvent("RebornCore:GetObject", function(obj) RebornCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

--- CODE0

local currentHouseGarage = nil
local hasGarageKey = nil
local currentGarage = nil
local OutsideVehicles = {}

RegisterNetEvent('cash-garagesystem:client:setHouseGarage')
AddEventHandler('cash-garagesystem:client:setHouseGarage', function(house, hasKey)
    currentHouseGarage = house
    hasGarageKey = hasKey
end)

RegisterNetEvent('cash-garagesystem:client:houseGarageConfig')
AddEventHandler('cash-garagesystem:client:houseGarageConfig', function(garageConfig)
    HouseGarages = garageConfig
end)

RegisterNetEvent('cash-garagesystem:client:addHouseGarage')
AddEventHandler('cash-garagesystem:client:addHouseGarage', function(house, garageInfo)
    HouseGarages[house] = garageInfo
end)

-- RegisterNetEvent('cash-garagesystem:client:takeOutDepot')
-- AddEventHandler('cash-garagesystem:client:takeOutDepot', function(vehicle)
--     if OutsideVehicles ~= nil and next(OutsideVehicles) ~= nil then
--         if OutsideVehicles[vehicle.plate] ~= nil then
--             local VehExists = DoesEntityExist(OutsideVehicles[vehicle.plate])
--             if not VehExists then
--                 RebornCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
--                     RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
--                         RebornCore.Functions.SetVehicleProperties(veh, properties)
--                         enginePercent = round(vehicle.engine / 10, 0)
--                         bodyPercent = round(vehicle.body / 10, 0)
--                         currentFuel = vehicle.fuel

--                         if vehicle.plate ~= nil then
--                             DeleteVehicle(OutsideVehicles[vehicle.plate])
--                             OutsideVehicles[vehicle.plate] = veh
--                             TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
--                         end

--                         if vehicle.status ~= nil and next(vehicle.status) ~= nil then
--                             TriggerServerEvent('cash-vehicletuner:server:LoadStatus', vehicle.status, vehicle.plate)
--                         end
                        
--                         if vehicle.drivingdistance ~= nil then
--                             local amount = round(vehicle.drivingdistance / 1000, -2)
--                             TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
--                             TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
--                         end

--                         if vehicle.vehicle == "urus" then
--                             SetVehicleExtra(veh, 1, false)
--                             SetVehicleExtra(veh, 2, true)
--                         end

--                         SetVehicleNumberPlateText(veh, vehicle.plate)
--                         SetEntityHeading(veh, Depots[currentGarage].takeVehicle.h)
--                         TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
--                         exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
--                         SetEntityAsMissionEntity(veh, true, true)
--                         doCarDamage(veh, vehicle)
--                         TriggerServerEvent('cash-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
--                         RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
--                         --closeMenuFull()
--                         SetVehicleEngineOn(veh, true, true)
--                     end, vehicle.plate)
--                     TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
--                 end, Depots[currentGarage].spawnPoint, true)
--             else
--                 local Engine = GetVehicleEngineHealth(OutsideVehicles[vehicle.plate])
--                 if Engine < 40.0 then
--                     RebornCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
--                         RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
--                             RebornCore.Functions.SetVehicleProperties(veh, properties)
--                             enginePercent = round(vehicle.engine / 10, 0)
--                             bodyPercent = round(vehicle.body / 10, 0)
--                             currentFuel = vehicle.fuel
    
--                             if vehicle.plate ~= nil then
--                                 DeleteVehicle(OutsideVehicles[vehicle.plate])
--                                 OutsideVehicles[vehicle.plate] = veh
--                                 TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
--                             end

--                             if vehicle.status ~= nil and next(vehicle.status) ~= nil then
--                                 TriggerServerEvent('cash-vehicletuner:server:LoadStatus', vehicle.status, vehicle.plate)
--                             end
                            
--                             if vehicle.drivingdistance ~= nil then
--                                 local amount = round(vehicle.drivingdistance / 1000, -2)
--                                 TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
--                                 TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
--                             end
    
--                             SetVehicleNumberPlateText(veh, vehicle.plate)
--                             SetEntityHeading(veh, Depots[currentGarage].takeVehicle.h)
--                             TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
--                             exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
--                             SetEntityAsMissionEntity(veh, true, true)
--                             doCarDamage(veh, vehicle)
--                             TriggerServerEvent('cash-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
--                             RebornCore.Functions.Notify("Vehicle Off: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
--                             --closeMenuFull()
--                             SetVehicleEngineOn(veh, true, true)
--                         end, vehicle.plate)
--                         TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
--                     end, Depots[currentGarage].spawnPoint, true)
--                 else
--                     RebornCore.Functions.Notify('You cannot duplicate this vehicle..', 'error')
--                     AddTemporaryBlip(OutsideVehicles[vehicle.plate])
--                 end
--             end
--         else
--             RebornCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
--                 RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
--                     RebornCore.Functions.SetVehicleProperties(veh, properties)
--                     enginePercent = round(vehicle.engine / 10, 0)
--                     bodyPercent = round(vehicle.body / 10, 0)
--                     currentFuel = vehicle.fuel

--                     if vehicle.plate ~= nil then
--                         OutsideVehicles[vehicle.plate] = veh
--                         TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
--                     end

--                     if vehicle.status ~= nil and next(vehicle.status) ~= nil then
--                         TriggerServerEvent('cash-vehicletuner:server:LoadStatus', vehicle.status, vehicle.plate)
--                     end

--                     SetVehicleNumberPlateText(veh, vehicle.plate)
--                     SetEntityHeading(veh, Depots[currentGarage].takeVehicle.h)
--                     TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
--                     exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
--                     SetEntityAsMissionEntity(veh, true, true)
--                     doCarDamage(veh, vehicle)
--                     TriggerServerEvent('cash-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
--                     RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
--                     --closeMenuFull()
--                     SetVehicleEngineOn(veh, true, true)
--                 end, vehicle.plate)
--                 TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
--             end, Depots[currentGarage].spawnPoint, true)
--         end
--     else
--         RebornCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
--             RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
--                 RebornCore.Functions.SetVehicleProperties(veh, properties)
--                 enginePercent = round(vehicle.engine / 10, 0)
--                 bodyPercent = round(vehicle.body / 10, 0)
--                 currentFuel = vehicle.fuel

--                 if vehicle.plate ~= nil then
--                     OutsideVehicles[vehicle.plate] = veh
--                     TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
--                 end

--                 if vehicle.status ~= nil and next(vehicle.status) ~= nil then
--                     TriggerServerEvent('cash-vehicletuner:server:LoadStatus', vehicle.status, vehicle.plate)
--                 end
                
--                 if vehicle.drivingdistance ~= nil then
--                     local amount = round(vehicle.drivingdistance / 1000, -2)
--                     TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
--                     TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
--                 end

--                 SetVehicleNumberPlateText(veh, vehicle.plate)
--                 SetEntityHeading(veh, Depots[currentGarage].takeVehicle.h)
--                 TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
--                 exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
--                 SetEntityAsMissionEntity(veh, true, true)
--                 doCarDamage(veh, vehicle)
--                 TriggerServerEvent('cash-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
--                 RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
--                 --closeMenuFull()
--                 SetVehicleEngineOn(veh, true, true)
--             end, vehicle.plate)
--             TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
--         end, Depots[currentGarage].spawnPoint, true)
--     end

--     TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
-- end)

-- function AddTemporaryBlip(vehicle)  
--     local VehicleCoords = GetEntityCoords(vehicle)
--     local TempBlip = AddBlipForCoord(VehicleCoords)
--     local VehicleData = RebornCore.Shared.VehicleModels[GetEntityModel(vehicle)]

--     SetBlipSprite (TempBlip, 225)
--     SetBlipDisplay(TempBlip, 4)
--     SetBlipScale  (TempBlip, 0.85)
--     SetBlipAsShortRange(TempBlip, true)
--     SetBlipColour(TempBlip, 0)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentSubstringPlayerName("Temp Blip: "..VehicleData["name"])
--     EndTextCommandSetBlipName(TempBlip)
--     RebornCore.Functions.Notify("Your "..VehicleData["name"].." is temporarily (1min) indicated on the map!", "success", 10000)

--     SetTimeout(60 * 1000, function()
--         RebornCore.Functions.Notify('Your vehicle is NOT shown on the map anymore!', 'error')
--         RemoveBlip(TempBlip)
--     end)
-- end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 128, 255, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    for k, v in pairs(Garages) do
        Garage = AddBlipForCoord(Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z)

        SetBlipSprite (Garage, 357)
        SetBlipDisplay(Garage, 2)
        SetBlipScale  (Garage, 0.65)
        SetBlipAsShortRange(Garage, true)
        SetBlipColour(Garage, 77)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Garages[k].label)
        EndTextCommandSetBlipName(Garage)
    end
end)

-- function yeet(label)
--     print(label)
-- end

function HouseGarage(house)
    RebornCore.Functions.TriggerCallback("cash-garage:server:GetHouseVehicles", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "Depot Vehicles :"
        ClearMenu()

        if result == nil then
            -- RebornCore.Functions.Notify("You have no vehicles in your garage", "error", 5000)
            TriggerEvent('reborn:notify:send', "Sistema","Você não tem carro na sua garagem","erro", 3500)

            --closeMenuFull()
        else
            Menu.addButton(HouseGarages[house].label, "yeet", HouseGarages[house].label)

            for k, v in pairs(result) do
                enginePercent = round(v.engine / 10, 0)
                bodyPercent = round(v.body / 10, 0)
                currentFuel = v.fuel
                curGarage = HouseGarages[house].label

                if v.state == 0 then
                    v.state = "Out"
                elseif v.state == 1 then
                    v.state = "Garage"
                elseif v.state == 2 then
                    v.state = "Depot"
                end
                
                local label = RebornCore.Shared.Vehicles[v.vehicle]["name"]
                if RebornCore.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                    label = RebornCore.Shared.Vehicles[v.vehicle]["brand"].." "..RebornCore.Shared.Vehicles[v.vehicle]["name"]
                end

                Menu.addButton(label, "TakeOutGarageVehicle", v, v.state, " Motor: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
            end
        end
            
        Menu.addButton("Back", "MenuHouseGarage", house)
    end, house)
end

-- function getPlayerVehicles(garage)
--     local vehicles = {}

--     return vehicles
-- end

-- function DepotLijst()
--     RebornCore.Functions.TriggerCallback("cash-garage:server:GetDepotVehicles", function(result)
--         ped = GetPlayerPed(-1);
--         MenuTitle = "Depot Vehicles :"
--         ClearMenu()

--         if result == nil then
--             RebornCore.Functions.Notify("There are no vehicles in the depot", "error", 5000)
--             --closeMenuFull()
--         else
--             Menu.addButton(Depots[currentGarage].label, "yeet", Depots[currentGarage].label)

--             for k, v in pairs(result) do
--                 enginePercent = round(v.engine / 10, 0)
--                 bodyPercent = round(v.body / 10, 0)
--                 currentFuel = v.fuel


--                 if v.state == 0 then
--                     v.state = "Depot"
--                 end

--                 local label = RebornCore.Shared.Vehicles[v.vehicle]["name"]
--                 if RebornCore.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
--                     label = RebornCore.Shared.Vehicles[v.vehicle]["brand"].." "..RebornCore.Shared.Vehicles[v.vehicle]["name"]
--                 end
--                 Menu.addButton(label, "TakeOutDepotVehicle", v, v.state .. " ($"..v.depotprice..")", " Motor: " .. enginePercent.."%", " Body: " .. bodyPercent.."%", " Fuel: "..currentFuel.."%")
--             end
--         end
            
--         Menu.addButton("Back", "MenuDepot",nil)
--     end)
-- end


RegisterNetEvent('Reborn:Garagem:Depot:Open')
AddEventHandler('Reborn:Garagem:Depot:Open', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    for k, v in pairs(Depots) do
        local takeDist = GetDistanceBetweenCoords(pos, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z)
        if takeDist <= 15 then
            currentGarage = k
            if not IsPedInAnyVehicle(ped) then
                RebornCore.Functions.TriggerCallback("cash-garage:server:GetDepotVehicles", function(result)
                    if result == nil then
                        TriggerEvent('reborn:notify:send', "Sistema","Não há veículos no depósito.","erro", 3500)
                    else


                        for k, v in pairs(result) do
                            enginePercent = round(v.engine / 10, 0)
                            bodyPercent = round(v.body / 10, 0)
                            currentFuel = v.fuel
            
            
                            if v.state == 0 then
                                v.state = "Depot"
                                SendNUIMessage({
                                    addcarro = true,
                                    imagem = v.vehicle,
                                    carro = RebornCore.Shared.Vehicles[v.vehicle]["name"],
                                    motor = round(v.engine / 10, 0),
                                    lataria = round(v.body / 10, 0),
                                    combustivel = v.fuel,
                                    garagem = "Deposito",
                                    status = v.state,
                                    kmh = v.drivingdistance,
                                    placa = v.plate,
                                    depot = true,
                                })
                            end

                            SetNuiFocus(true, true)
                        end
                        
                    end
                end, currentGarage)
            else
                return
            end
        end
    end
end)

RegisterNetEvent('Reborn:JobGaragem:Open')
AddEventHandler('Reborn:JobGaragem:Open', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    for k, v in pairs(JobGaragens) do
        local takeDist = GetDistanceBetweenCoords(pos, JobGaragens[k].takeVehicle.x, JobGaragens[k].takeVehicle.y, JobGaragens[k].takeVehicle.z)

        if takeDist <= 15 then
            RebornCore.Functions.GetPlayerData(function(PlayerData)

                if PlayerData.job.name == v.Job or PlayerData.job.name == v.Job2 then
                    if not IsPedInAnyVehicle(ped) then
                        for _, info in pairs(v.carros) do
                            -- print(info.carro)

                            SendNUIMessage({
                                addcarro = true,
                                imagem = info.carro,
                                carro = info.carro,
                                motor = info.motor,
                                lataria = info.lataria,
                                combustivel = info.combustivel,
                                garagem = v.label,
                                status = 'Garagem',
                                kmh = 'Não informado',
                                placa = info.carro,
                                depot = false,
                            })
                            SetNuiFocus(true, true)
                        end
                    else
                      return
                    end
                elseif v.Job == "all" then
                    if not IsPedInAnyVehicle(ped) then
                        for _, info in pairs(v.carros) do
                            -- print(info.carro)

                            SendNUIMessage({
                                addcarro = true,
                                imagem = info.carro,
                                carro = info.carro,
                                motor = info.motor,
                                lataria = info.lataria,
                                combustivel = info.combustivel,
                                garagem = v.label,
                                status = 'Garagem',
                                kmh = 'Não informado',
                                placa = info.carro,
                                depot = false,
                            })
                            SetNuiFocus(true, true)
                        end
                    else
                        return
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('Reborn:Garagem:Open')
AddEventHandler('Reborn:Garagem:Open', function()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)

    for k, v in pairs(Garages) do
        local takeDist = GetDistanceBetweenCoords(pos, Garages[k].takeVehicle.x, Garages[k].takeVehicle.y, Garages[k].takeVehicle.z)
        if takeDist <= 15 then
            currentGarage = k
            if not IsPedInAnyVehicle(ped) then
                RebornCore.Functions.TriggerCallback("cash-garage:server:GetUserVehicles", function(result)
                    if result == nil then
                        TriggerEvent('reborn:notify:send', "Sistema","Nenhum veículo nesta garagem","erro", 3500)
                        -- --closeMenuFull()
                    else
                        for k, v in pairs(result) do
                            enginePercent = round(v.engine / 10, 0)
                            bodyPercent = round(v.body / 10, 0)
                            currentFuel = v.fuel
                            curGarage = Garages[v.garage].label
            
                            if v.state == 0 then
                                v.state = "Out"
                            elseif v.state == 1 then
                                v.state = "Garage"
                            elseif v.state == 2 then
                                v.state = "In Impound"
                            end
            
                            SendNUIMessage({
                                addcarro = true,
                                imagem = v.vehicle,
                                carro = RebornCore.Shared.Vehicles[v.vehicle]["name"],
                                motor = round(v.engine / 10, 0),
                                lataria = round(v.body / 10, 0),
                                combustivel = v.fuel,
                                garagem = Garages[v.garage].label,
                                status = v.state,
                                kmh = v.drivingdistance,
                                placa = v.plate,
                                depot = false,
                            })

                            SetNuiFocus(true, true)
            
                            local label = RebornCore.Shared.Vehicles[v.vehicle]["name"]
                            if RebornCore.Shared.Vehicles[v.vehicle]["brand"] ~= nil then
                                label = RebornCore.Shared.Vehicles[v.vehicle]["brand"].." "..RebornCore.Shared.Vehicles[v.vehicle]["name"]
                            end
                        end
                    end
                end, currentGarage)
            else
                return
            end
        end
    end
end)

RegisterNUICallback('Reborn:Garagem:Close', function(data, cb)
    SetNuiFocus(false, false)
end)


-- function TakeOutDepotVehicle(vehicle)
--     if vehicle.state == "Depot" then
--         TriggerServerEvent("cash-garage:server:PayDepotPrice", vehicle)
--     end
-- end




RegisterNetEvent('Reborn:Depot:SpawnCarro')
AddEventHandler('Reborn:Depot:SpawnCarro', function(placa)
    RebornCore.Functions.TriggerCallback("cash-garage:server:GetDepotVehicles", function(result)
        for k, v in pairs(result) do
            if v.plate == placa then
                if v.state == 0 then

                    if OutsideVehicles ~= nil and next(OutsideVehicles) ~= nil then
                        if OutsideVehicles[v.plate] ~= nil then
                            local VehExists = DoesEntityExist(OutsideVehicles[v.plate])
                            -- print(VehExists)
                            if not VehExists then
                                RebornCore.Functions.SpawnVehicle(v.vehicle, function(veh)
                                    RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
                                        -- print('entrou aqui2')
                                        if v.plate ~= nil then
                                            OutsideVehicles[v.plate] = veh
                                            TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
                                        end
                        
                                        if v.status ~= nil and next(v.status) ~= nil then
                                            TriggerServerEvent('cash-vehicletuner:server:LoadStatus', v.status, v.plate)
                                        end
                        
                                        if v.vehicle == "urus" then
                                            SetVehicleExtra(veh, 1, false)
                                            SetVehicleExtra(veh, 2, true)
                                        end
                                        
                                        if v.drivingdistance ~= nil then
                                            local amount = round(v.drivingdistance / 1000, -2)
                                            TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
                                            TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', v.drivingdistance, v.plate)
                                        end
                        
                                        RebornCore.Functions.SetVehicleProperties(veh, properties)
                                        SetVehicleNumberPlateText(veh, v.plate)
                                        -- SetEntityHeading(veh, Depots[currentGarage].spawnPoint.h)
                                        SetEntityHeading(veh, Depots[currentGarage].spawnPoint.h)
                                        exports['LegacyFuel']:SetFuel(veh, v.fuel)
                                        doCarDamage(veh, v)
                                        SetEntityAsMissionEntity(veh, true, true)
                                        TriggerServerEvent('cash-garage:server:updateVehicleState', 0, v.plate, v.garage)
                                        -- RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                                        TriggerEvent('reborn:notify:send', "Sistema","Veículo retirado da garagem","sucesso", 3500)
                                        -- --closeMenuFull()
                                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                        SetVehicleEngineOn(veh, true, true)
                                    end, v.plate)
                                end, Depots[currentGarage].spawnPoint, true)
                            end
                        end
                    else
                        RebornCore.Functions.SpawnVehicle(v.vehicle, function(veh)
                            RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
                                -- print('entrou aqui2')
                                if v.plate ~= nil then
                                    OutsideVehicles[v.plate] = veh
                                    TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
                                end
                
                                if v.status ~= nil and next(v.status) ~= nil then
                                    TriggerServerEvent('cash-vehicletuner:server:LoadStatus', v.status, v.plate)
                                end
                
                                if v.vehicle == "urus" then
                                    SetVehicleExtra(veh, 1, false)
                                    SetVehicleExtra(veh, 2, true)
                                end
                                
                                if v.drivingdistance ~= nil then
                                    local amount = round(v.drivingdistance / 1000, -2)
                                    TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
                                    TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', v.drivingdistance, v.plate)
                                end
                
                                RebornCore.Functions.SetVehicleProperties(veh, properties)
                                SetVehicleNumberPlateText(veh, v.plate)
                                -- SetEntityHeading(veh, Depots[currentGarage].spawnPoint.h)
                                SetEntityHeading(veh, Depots[currentGarage].spawnPoint.h)
                                exports['LegacyFuel']:SetFuel(veh, v.fuel)
                                doCarDamage(veh, v)
                                SetEntityAsMissionEntity(veh, true, true)
                                TriggerServerEvent('cash-garage:server:updateVehicleState', 0, v.plate, v.garage)
                                -- RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                                TriggerEvent('reborn:notify:send', "Sistema","Veículo retirado da garagem","sucesso", 3500)
                                -- --closeMenuFull()
                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, v.plate)
                        end, Depots[currentGarage].spawnPoint, true)
                    end
                end
            end
        end
    end, currentGarage)
end)

RegisterNUICallback('Reborn:Depot:SpawnCarro', function(data, cb)
    TriggerServerEvent("Reborn:Deposito:Pagamento", data.placa)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Reborn:Garagem:SpawnCarro', function(data, cb)
    if data.lista == true then
        RebornCore.Functions.TriggerCallback("cash-garage:server:GetUserVehicles", function(result)
            for k, v in pairs(result) do
                if v.plate == data.placa then
                    if v.state == 1 then
                        RebornCore.Functions.SpawnVehicle(v.vehicle, function(veh)
                            RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
                
                                if v.plate ~= nil then
                                    OutsideVehicles[v.plate] = veh
                                    TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
                                end
                
                                if v.status ~= nil and next(v.status) ~= nil then
                                    TriggerServerEvent('cash-vehicletuner:server:LoadStatus', v.status, v.plate)
                                end
                
                                if v.vehicle == "urus" then
                                    SetVehicleExtra(veh, 1, false)
                                    SetVehicleExtra(veh, 2, true)
                                end
                                
                                if v.drivingdistance ~= nil then
                                    local amount = round(v.drivingdistance / 1000, -2)
                                    TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
                                    TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', v.drivingdistance, v.plate)
                                end
                
                                RebornCore.Functions.SetVehicleProperties(veh, properties)
                                SetVehicleNumberPlateText(veh, v.plate)
                                SetEntityHeading(veh, Garages[currentGarage].spawnPoint.h)
                                exports['LegacyFuel']:SetFuel(veh, v.fuel)
                                doCarDamage(veh, v)
                                SetEntityAsMissionEntity(veh, true, true)
                                TriggerServerEvent('cash-garage:server:updateVehicleState', 0, v.plate, v.garage)
                                -- RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
                                --closeMenuFull()
                                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, v.plate)
                            SetNuiFocus(false, false)
                        end, Garages[currentGarage].spawnPoint, true)
                        
                    else
                        print('ter uma notificação pro infeliz'.. v.state)
                        SetNuiFocus(false, false)
                    end
                end
            end
        end, currentGarage)
    else
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        for k, v in pairs(JobGaragens) do
            local takeDist = GetDistanceBetweenCoords(pos, JobGaragens[k].takeVehicle.x, JobGaragens[k].takeVehicle.y, JobGaragens[k].takeVehicle.z)
            if takeDist <= 15 then
                RebornCore.Functions.GetPlayerData(function(PlayerData)
                    if PlayerData.job.name == v.Job or PlayerData.job.name == v.Job2 then
                        RebornCore.Functions.SpawnVehicle(data.placa, function(veh)
                            SetVehicleNumberPlateText(veh, "EMP"..tostring(math.random(1000, 9999)))
                            SetEntityHeading(veh, JobGaragens[k].spawnPoint.h)
                            exports['LegacyFuel']:SetFuel(veh, 100.0)
                            --closeMenuFull()
                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                            SetVehicleEngineOn(veh, true, true)
                            SetNuiFocus(false, false)
                        end, JobGaragens[k].spawnPoint, true)
                    elseif v.Job == "all" then 
                        RebornCore.Functions.SpawnVehicle(data.placa, function(veh)
                            SetVehicleNumberPlateText(veh, "EMP"..tostring(math.random(1000, 9999)))
                            SetEntityHeading(veh, JobGaragens[k].spawnPoint.h)
                            exports['LegacyFuel']:SetFuel(veh, 100.0)
                            --closeMenuFull()
                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                            SetVehicleEngineOn(veh, true, true)
                            SetNuiFocus(false, false)
                        end, JobGaragens[k].spawnPoint, true)
                    end
                end)
            end
        end
    end
end)


function dump(t, indent, done)
    done = done or {}
    indent = indent or 0

    done[t] = true

    for key, value in pairs(t) do
        print(string.rep("\t", indent))

        if (type(value) == "table" and not done[value]) then
            done[value] = true
            print(key, ":\n")

            dump(value, indent + 2, done)
            done[value] = nil
        else
            print(key, "\t=\t", value, "\n")
        end
    end
end


-- function TakeOutVehicle(vehicle)
--     print(dump(vehicle))
--     if vehicle.state == "Garage" then
--         enginePercent = round(vehicle.engine / 10, 1)
--         bodyPercent = round(vehicle.body / 10, 1)
--         currentFuel = vehicle.fuel

--         RebornCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
--             RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)

--                 if vehicle.plate ~= nil then
--                     OutsideVehicles[vehicle.plate] = veh
--                     TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
--                 end

--                 if vehicle.status ~= nil and next(vehicle.status) ~= nil then
--                     TriggerServerEvent('cash-vehicletuner:server:LoadStatus', vehicle.status, vehicle.plate)
--                 end

--                 if vehicle.vehicle == "urus" then
--                     SetVehicleExtra(veh, 1, false)
--                     SetVehicleExtra(veh, 2, true)
--                 end
                
--                 if vehicle.drivingdistance ~= nil then
--                     local amount = round(vehicle.drivingdistance / 1000, -2)
--                     TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
--                     TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
--                 end

--                 RebornCore.Functions.SetVehicleProperties(veh, properties)
--                 SetVehicleNumberPlateText(veh, vehicle.plate)
--                 SetEntityHeading(veh, Garages[currentGarage].spawnPoint.h)
--                 exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
--                 doCarDamage(veh, vehicle)
--                 SetEntityAsMissionEntity(veh, true, true)
--                 TriggerServerEvent('cash-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
--                 RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
--                 --closeMenuFull()
--                 TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
--                 TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
--                 SetVehicleEngineOn(veh, true, true)
--             end, vehicle.plate)
            
--         end, Garages[currentGarage].spawnPoint, true)
--     elseif vehicle.state == "Out" then
--         RebornCore.Functions.Notify("Is your vehicle in the depot??", "error", 2500)
--     elseif vehicle.state == "In Impound" then
--         RebornCore.Functions.Notify("This vehicle has been seized by the Police", "error", 4000)
--     end
-- end

-- RegisterCommand('g',function(source,args,rawCommand)
-- 	local jogador1 = PlayerPedId()
-- 	if jogador1 then
-- 		TriggerEvent('reborn:open:garagem')
-- 	end	
-- end)

local toggle = "none"



RegisterNetEvent('reborn:open:garagem')
AddEventHandler('reborn:open:garagem', function()
	if toggle == "none" then
		SendNUIMessage({
			desativar = "flex"
		})
          toggle = "flex"
          SetNuiFocus(true, true)
	elseif toggle == "flex" then
		SendNUIMessage({
			desativar = "none",
            limpando = true,
		})
          toggle = "none"
          SetNuiFocus(false, false)
	end
end)


-- function TakeOutDepotVehicle(vehicle)
--     if vehicle.state == "Depot" then
--         TriggerServerEvent("cash-garage:server:PayDepotPrice", vehicle)
--     end
-- end

-- function TakeOutGarageVehicle(vehicle)
--     if vehicle.state == "Garage" then
--         RebornCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
--             RebornCore.Functions.TriggerCallback('cash-garage:server:GetVehicleProperties', function(properties)
--                 RebornCore.Functions.SetVehicleProperties(veh, properties)
--                 enginePercent = round(vehicle.engine / 10, 1)
--                 bodyPercent = round(vehicle.body / 10, 1)
--                 currentFuel = vehicle.fuel

--                 if vehicle.plate ~= nil then
--                     OutsideVehicles[vehicle.plate] = veh
--                     TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
--                 end
                
                
--                 if vehicle.drivingdistance ~= nil then
--                     local amount = round(vehicle.drivingdistance / 1000, -2)
--                     TriggerEvent('cash-overallhud:client:UpdateDrivingMeters', true, amount)
--                     TriggerServerEvent('cash-vehicletuner:server:UpdateDrivingDistance', vehicle.drivingdistance, vehicle.plate)
--                 end

--                 if vehicle.vehicle == "urus" then
--                     SetVehicleExtra(veh, 1, false)
--                     SetVehicleExtra(veh, 2, true)
--                 end

--                 if vehicle.status ~= nil and next(vehicle.status) ~= nil then
--                     TriggerServerEvent('cash-vehicletuner:server:LoadStatus', vehicle.status, vehicle.plate)
--                 end

--                 SetVehicleNumberPlateText(veh, vehicle.plate)
--                 SetEntityHeading(veh, HouseGarages[currentHouseGarage].takeVehicle.h)
--                 TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
--                 exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
--                 SetEntityAsMissionEntity(veh, true, true)
--                 doCarDamage(veh, vehicle)
--                 TriggerServerEvent('cash-garage:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
--                 RebornCore.Functions.Notify("Vehicle out: Motor: " .. enginePercent .. "% Body: " .. bodyPercent.. "% Fuel: "..currentFuel.. "%", "primary", 4500)
--                 --closeMenuFull()
--                 TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
--                 SetVehicleEngineOn(veh, true, true)
--             end, vehicle.plate)
--         end, HouseGarages[currentHouseGarage].takeVehicle, true)
--     end
-- end

function doCarDamage(currentVehicle, veh)
	smash = false
	damageOutside = false
	damageOutside2 = false 
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end
    
    if engine > 1000.0 then
        engine = 1000.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 900.0 then
		smash = true
	end

	if body < 800.0 then
		damageOutside = true
	end

	if body < 500.0 then
		damageOutside2 = true
	end

    Citizen.Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(Garages) do
            local putDist = GetDistanceBetweenCoords(pos, Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z)

            if putDist <= 25 and IsPedInAnyVehicle(ped) then
                inGarageRange = true
                -- DrawMarker(36, Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z, 0, 0, 0, 0, 0, 0.9, 0.5, 0.9, 0.9, 0, 127, 0, 255, true, true, false, false, false, false, false)
                if putDist <= 2.5 then
                    DrawText3Ds(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z + 0.5, '~b~E~w~ - Guardar Veículo')
                    if IsControlJustPressed(0, 38) then
                        local curVeh = GetVehiclePedIsIn(ped)
                        local plate = GetVehicleNumberPlateText(curVeh)
                        RebornCore.Functions.TriggerCallback('cash-garage:server:checkVehicleOwner', function(owned)
                            if owned then
                                local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
                                local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
                                local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
        
                                TriggerServerEvent('cash-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, k)
                                TriggerServerEvent('cash-garage:server:updateVehicleState', 1, plate, k)
                                TriggerServerEvent('vehiclemod:server:saveStatus', plate)
                                RebornCore.Functions.DeleteVehicle(curVeh)
                                if plate ~= nil then
                                    OutsideVehicles[plate] = veh
                                    TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
                                end
                                -- RebornCore.Functions.Notify("Vehicle stored in, "..Garages[k].label, "primary", 4500)
                                TriggerEvent('reborn:notify:send', "Sistema","Carro Guardado","sucesso", 3500)
                            else
                                TriggerEvent('reborn:notify:send', "Sistema","Ninguem é dono deste veículo","erro", 3500)
                            end
                        end, plate)
                    end
                elseif putDist <= 10 then 
                    DrawText3Ds(Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z + 0.5, 'Guardar Veículo')
                end 
            end
        end

        if not inGarageRange then
            Citizen.Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        for k, v in pairs(JobGaragens) do
            local putDist = GetDistanceBetweenCoords(pos, JobGaragens[k].putVehicle.x, JobGaragens[k].putVehicle.y, JobGaragens[k].putVehicle.z)

            if putDist <= 25 and IsPedInAnyVehicle(ped) then
                inGarageRange = true
                -- DrawMarker(36, Garages[k].putVehicle.x, Garages[k].putVehicle.y, Garages[k].putVehicle.z, 0, 0, 0, 0, 0, 0.9, 0.5, 0.9, 0.9, 0, 127, 0, 255, true, true, false, false, false, false, false)
                if putDist <= 2.5 then
                    DrawText3Ds(JobGaragens[k].putVehicle.x, JobGaragens[k].putVehicle.y, JobGaragens[k].putVehicle.z + 0.5, '~b~E~w~ - Guardar Veículo')
                    if IsControlJustPressed(0, 38) then
                        local curVeh = GetVehiclePedIsIn(ped)
                        local plate = GetVehicleNumberPlateText(curVeh)
                        if JobGaragens[k].label == "Garagem de Barcos" then
                            local persocar = PlayerPedId()
                            RebornCore.Functions.DeleteVehicle(curVeh)
                            SetEntityCoords(persocar, JobGaragens[k].CharacterOut.x, JobGaragens[k].CharacterOut.y, JobGaragens[k].CharacterOut.z)
                        else
                            RebornCore.Functions.DeleteVehicle(curVeh)
                        end
                    end
                elseif putDist <= 10 then 
                    DrawText3Ds(JobGaragens[k].putVehicle.x, JobGaragens[k].putVehicle.y, JobGaragens[k].putVehicle.z + 0.5, 'Guardar Veículo')
                end 
            end
        end

        if not inGarageRange then
            Citizen.Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        Citizen.Wait(1000)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inGarageRange = false

        if HouseGarages ~= nil and currentHouseGarage ~= nil then
            if hasGarageKey and HouseGarages[currentHouseGarage] ~= nil then
                local takeDist = GetDistanceBetweenCoords(pos, HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z)
                if takeDist <= 15 then
                    inGarageRange = true
                    DrawMarker(36, HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.3, 1.2, 1.15, 200, 127, 0, 222, false, false, false, true, false, false, false)
                    if takeDist < 2.0 then
                        if not IsPedInAnyVehicle(ped) then
                            Citizen.Wait(5)
                            DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - Garage')
                            if IsControlJustPressed(1, 177) and not Menu.hidden then
                                close()
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            end
                            if IsControlJustPressed(0, 38) then
                                MenuHouseGarage(currentHouseGarage)
                                Menu.hidden = not Menu.hidden
                            end
                        elseif IsPedInAnyVehicle(ped) then
                            DrawText3Ds(HouseGarages[currentHouseGarage].takeVehicle.x, HouseGarages[currentHouseGarage].takeVehicle.y, HouseGarages[currentHouseGarage].takeVehicle.z + 0.5, '~g~E~w~ - Store')
                            if IsControlJustPressed(0, 38) then
                                local curVeh = GetVehiclePedIsIn(ped)
                                local plate = GetVehicleNumberPlateText(curVeh)
                                RebornCore.Functions.TriggerCallback('cash-garage:server:checkVehicleHouseOwner', function(owned)
                                    if owned then
                                        local bodyDamage = round(GetVehicleBodyHealth(curVeh), 1)
                                        local engineDamage = round(GetVehicleEngineHealth(curVeh), 1)
                                        local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
                
                                        TriggerServerEvent('cash-garage:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, currentHouseGarage)
                                        TriggerServerEvent('cash-garage:server:updateVehicleState', 1, plate, currentHouseGarage)
                                        RebornCore.Functions.DeleteVehicle(curVeh)
                                        if plate ~= nil then
                                            OutsideVehicles[plate] = veh
                                            TriggerServerEvent('cash-garagesystem:server:UpdateOutsideVehicles', OutsideVehicles)
                                        end
                                        -- RebornCore.Functions.Notify("Vehicle stored, "..HouseGarages[currentHouseGarage].label, "primary", 4500)
                                        TriggerEvent('reborn:notify:send', "Sistema","Carro guardado","sucesso", 3500)
                                    else
                                        -- RebornCore.Functions.Notify("No one owns this vehicle...", "error", 3500)
                                        TriggerEvent('reborn:notify:send', "Sistema","Este veículo não é seu.","erro", 3500)
                                    end
                                end, plate, currentHouseGarage)
                            end
                        end
                        
                        Menu.renderGUI()
                    end

                    if takeDist > 1.99 and not Menu.hidden then
                        --closeMenuFull()
                    end
                end
            end
        end
        
        if not inGarageRange then
            Citizen.Wait(5000)
        end
    end
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(1000)
--     while true do
--         Citizen.Wait(5)
--         local ped = GetPlayerPed(-1)
--         local pos = GetEntityCoords(ped)
--         local inGarageRange = false

--         for k, v in pairs(Depots) do
--             local takeDist = GetDistanceBetweenCoords(pos, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z)
--             if takeDist <= 15 then
--                 inGarageRange = true
--                 DrawMarker(36, Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z, 0.0, 0.0, 1.5, 1.0, 1.5, 1.5, 1.5, 1, 1.15, 235, 247, 0, 222, false, false, false, true, false, false, false)
--                 if takeDist <= 1.5 then
--                     if not IsPedInAnyVehicle(ped) then
--                         DrawText3Ds(Depots[k].takeVehicle.x, Depots[k].takeVehicle.y, Depots[k].takeVehicle.z + 0.5, '~g~E~w~ - Towed Veh/Depot')
--                         if IsControlJustPressed(1, 177) and not Menu.hidden then
--                             close()
--                             PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
--                         end
--                         if IsControlJustPressed(0, 38) then
--                             TriggerEvent('Reborn:Garagem:Depot:Open')
--                         end
--                     end
--                 end

--                 Menu.renderGUI()

--                 if takeDist >= 4 and not Menu.hidden then
--                     --closeMenuFull()
--                 end
--             end
--         end

--         if not inGarageRange then
--             Citizen.Wait(5000)
--         end
--     end
-- end)

function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces>0 then
      local mult = 10^numDecimalPlaces
      return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end