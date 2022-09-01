RegisterCommand("calltaxi", function(source, args, rawCommand)
    local plyPed = PlayerPedId()
    local npc = nil
    local veh = nil
    local plyCoords = GetEntityCoords(plyPed)
    local nearestSpawn = nil

    nearestSpawn = GetNearestSpawn(plyCoords)
    
end)


function GetNearestSpawn(plyCoords){			-- TO DO nächsten spawnpunkt berechnen
	
	return nearestSpawn
}
