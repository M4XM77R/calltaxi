ESX = nil
local plyPed = PlayerPedId()
local plyCoords = GetEntityCoords(plyPed)
local taxiCoords = nil
local npc = nil
local veh = nil
local nearestSpawn = nil
local isTaxiAlreadyOrdered = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand("calltaxi", function(source, args, rawCommand)
    plyCoords = GetEntityCoords(plyPed)
    if not isTaxiAlreadyOrdered then
        ShowNotification("Ok, ein Taxi ist bestellt")
        isTaxiAlreadyOrdered = true
        for k,v in pairs(Config.SpawnPoints) do                        -- Gets closest Spawnpoint
            heading = v.h
            v = vector3(v.x, v.y, v.z)
            spawnDistance = GetDistanceBetweenCoords(plyCoords, v)
            if oldDistance then
                if spawnDistance < oldDistance then
                    oldDistance = spawnDistance
                    realSpawnPoint = v
                else
                    oldDistance = oldDistance
                end
            else
                oldDistance = spawnDistance
                realSpawnPoint = v
            end
        end
        print(realSpawnPoint)
        while not HasModelLoaded(Config.hash) do            --check if models are loaded
            RequestModel(Config.hash)
            print('loading model')
            Wait(50)
        end
        while not HasModelLoaded(Config.vehicleHash) do
            RequestModel(Config.vehicleHash)
            print('loading vehModel')
            Wait(50)
        end
        npc = CreatePed(0, Config.hash, realSpawnPoint.x, realSpawnPoint.y, realSpawnPoint.z, 0,0, true, true)
        veh = CreateVehicle(Config.vehicleHash, realSpawnPoint.x, realSpawnPoint.y, realSpawnPoint.z, 0,0, true, true)
        SetEntityAsMissionEntity(veh, true, true)
        TaskWarpPedIntoVehicle(npc, veh, -1)
        SetVehicleHasBeenOwnedByPlayer(veh, true)
        Wait(math.random(1000,2000))
        TaskVehicleDriveToCoord(npc, veh, plyCoords.x + 2, plyCoords.y + 2, plyCoords.z, 75.0, Config.DriveMode, 10.0)
        ShowNotification('Das Taxi fährt gerade los')
        TaxiBlib = AddBlipForEntity(veh)
        SetBlipAsFriendly(TaxiBlip, true)                                                                        
        while true do
            Wait(10)
            taxiCoords = GetEntityCoords(npc)
            dist = (plyCoords.xy - taxiCoords.xy)
            if (dist.x < 2.0) and (dist.y < 2.0) then -- taxi hält durchaus auch mal so 1200 units weg an und denkt so "ja wo is er jz"
                FreezeEntityPosition(veh, true)
                FreezeEntityPosition(npc, true)
                ClearVehicleTasks(veh)
                print('halt an du dulli')
                break
            end
        end

        isTaxiAlreadyOrdered = false
    else
        ShowNotification("Es ist schon ein Taxi auf dem Weg")
    end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false) 
end

--[[ESX.Game.SpawnVehicle(vehicleHash, realSpawnPoint, heading, function(callback_vehicle)
    TaskWarpPedIntoVehicle(ped, callback_vehicle, -1)
    SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
    globalTaxi = callback_vehicle
    SetEntityAsMissionEntity(globalTaxi, true, true)
    drive(customer.x, customer.y, customer.z, false, 'start')
    end)]]
    
    FreezeEntityPosition(veh, true)
    FreezeEntityPosition(npc, true)





--[[

function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_policejob:updateBlip')
AddEventHandler('esx_policejob:updateBlip', function()

	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsCops = {}
]]

--HERE