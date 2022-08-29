RegisterCommand("calltaxi", function(source, args, rawCommand)

local plyPed = PlayerPedId()
local npc = nil
local plyCoords = GetEntityCoords(plyPed)

    npc = CreatePed(4, Config.NpcHash, plyCoords.x, plyCoords.y, plyCoords.z, 0, true, true)
end)