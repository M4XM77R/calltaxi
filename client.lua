local plyPed = PlayerPedId()
local plyCoords = GetEntityCoords(plyPed)
local taxiCoords = nil
local npc = nil
local veh = nil
local nearestSpawn = nil
local isTaxiAlreadyOrdered = false

RegisterCommand("calltaxi", function(source, args, rawCommand)
    plyCoords = GetEntityCoords(plyPed)
    if not isTaxiAlreadyOrdered then
        ShowNotification("Ok, ein Taxi ist bestellt")
        isTaxiAlreadyOrdered = true
        for k,v in pairs(Config.SpawnPoints) do
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
        while not HasModelLoaded(Config.hash) do
            RequestModel(Config.hash)
            print('loading model')
            Wait(50)
        end
        while not HasModelLoaded(Config.vehicleHash) do
            RequestModel(Config.vehicleHash)
            print('loading vehModel')
            Wait(50)
        end
        npc = CreatePed(0, Config.hash, realSpawnPoint.x, realSpawnPoint.y, realSpawnPoint.z + 2, 0,0, true, true)
        veh = CreateVehicle(Config.vehicleHash, realSpawnPoint.x, realSpawnPoint.y, realSpawnPoint.z, 0,0, true, true)
        SetEntityAsMissionEntity(veh, true, true)
        TaskWarpPedIntoVehicle(npc, veh, -1)
        Wait(math.random(1000,2000))
        ShowNotification('Das Taxi fährt gerade los')                                                                            --ISSUE: Taxi fährt nicht los
        TaskVehicleDriveToCoordLongrange(npc, veh, plyCoords.x, plyCoords.y, plyCoords.z, Config.speed, Config.DriveMode, 20.0)
        while true do
            Wait(1)
            taxiCoords = GetEntityCoords(npc)
            dist = (plyCoords.xy - taxiCoords.xy)
            if dist < 50 then
                ClearVehicleTasks(veh)
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
