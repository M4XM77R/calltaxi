RegisterCommand("calltaxi", function(source, args, rawCommand)
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)
    local npc = nil
    local veh = nil
    local nearestSpawn = nil

    nearestSpawn = GetNearestSpawn(plyCoords)
    
end)


function GetNearestSpawn(plyCoords)			-- TO DO nächsten spawnpunkt berechnen
	local toDownTownCab = nil
	toDownTownCab = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, 0, Config.SpawnPoints.DownTownCab.x, Config.SpawnPoints.DownTownCab.y, 0, false)
	print toDownTownCab
	return nearestSpawn
end
