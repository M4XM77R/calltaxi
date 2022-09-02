RegisterCommand("calltaxi", function(source, args, rawCommand)
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)
    local npc = nil
    local veh = nil
    local nearestSpawn = nil

    nearestSpawn = GetNearestSpawn(plyCoords)
    
end)


function GetNearestSpawn(plyCoords)			-- TO DO nächsten spawnpunkt berechnen
	
	return nearestSpawn
end

function getClosestCoords(_table) -- Function that returns
    local cCoords = nil -- Replaced with the closest coordinates
    local cDistance = 100000 -- This is replaced by the closest distance we are to any coordinates
    local plyPed = PlayerPedId()
    local coords = GetEntityCoords(plyPed)

    for _, v in pairs(Config.SpawnPoints) do -- Loop through a table with coordinates
        local _Distance = #(v - _Coord)
        if _Distance <= cDistance then
            cDistance = _Distance
            cCoords = v
        end
    end
    print(coords)
    return cCoords
end
