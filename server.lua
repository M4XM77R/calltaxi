--setting locals
local plyPed = GetPlayerPed(-1)
local plyCoords = GetEntityCoords(plyPed)
local taxiCoords = nil
local npc = nil
local veh = nil
local nearestSpawn = nil
local isTaxiAlreadyOrdered = false
--Command

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
        --Drive(plyCoords.x, plyCoords.y, plyCoords.z, false, "start")
        ShowNotification('Das Taxi fährt gerade los')
        TaskVehicleDriveToCoordLongrange(npc, veh, plyCoords.x, plyCoords.y, plyCoords.z, Config.Speed, Config.DriveMode, 20.0)
        CreateBlip()


        while true do
            Wait(1)
            taxiCoords = GetEntityCoords(npc)
            dist = (plyCoords.xy - taxiCoords.xy)
            if (dist.x < 2.0) and (dist.y < 2.0) and (dist.x < -2.0) and (dist.y < -2.0) then
                FreezeEntityPosition(veh, true)
                FreezeEntityPosition(npc, true)
                ClearVehicleTasks(veh)
                print('Anjehalten!')
                break
            end
        end

        isTaxiAlreadyOrdered = false

    else

        ShowNotification('is schon ein Taxi aufm Weg')
    
    end
end)






--ESX = nil
--local plyPed = PlayerPedId()
--local plyCoords = GetEntityCoords(plyPed)
--local taxiCoords = nil
--local npc = nil
--local veh = nil
--local nearestSpawn = nil
--local isTaxiAlreadyOrdered = false


--[[Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)]]



--Add Notifications
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false) 
end


-- Creating Blip
function CreateBlip()
    local blip = GetBlipFromEntity(npc)
    if not DoesBlipExist(blip) then -- Add blip
        blip = AddBlipForEntity(npc) -- Create and "Stick" the Blip to Entity
        SetBlipSprite(blip, Config.BlipSprite)
        SetBlipColour(blip, Config.BlipColor)
        SetBlipScale(blip, Config.BlipScale)
        ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
        SetBlipRotation(blip, math.ceil(GetEntityHeading(npc))) -- update rotation
        SetBlipAsShortRange(blip, false)
    end
end



--add drive Function
--[[function drive(x, y, z, delete, status)
	if status == 'start' then
		Citizen.Wait(math.random(1000,3000))
		ShowNotification('Ein Fahrer ist auf dem Weg zu Ihnen.')
	elseif status == 'end' then
		ShowNotification('Vielen Dank für Ihr Vertrauen.')
	end
	TaskVehicleDriveToCoordLongrange(npc, veh, x, y, z, Config.Speed, Config.DriveMode, 20.0)
	if delete then
		Citizen.Wait(15000)
		DeletePed(ped)
		DeleteVehicle(veh)
	end
end]]



--[[
RegisterNetEvent('esx_policejob:updateBlip')
AddEventHandler('esx_policejob:updateBlip', function()

	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsCops = {}
]]