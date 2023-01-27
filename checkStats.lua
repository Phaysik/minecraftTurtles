-- Author: Matthew Moore
-- File: checkStats.lua
-- Brief: Lua file for dealing with the chicken's stats.
-- Details: Contains the function definitions for dealing with the chicken's stats
-- Date: 01/27/2023
-- Version: 1.0

local stats = {}

function stats.getStats(peripheral, outputFile, debug)
    local file = fs.open(outputFile, "w")

    local chickenStats = {}

    for i = 4, 6 do
        if peripheral.getItemMeta(i) then -- Needs the Plethora mod to access the NBT data through this method call
            table.insert(chickenStats, peripheral.getItemMeta(i))
            if debug then
                file.write(textutils.serialize(peripheral.getItemMeta(i)))
            end
        else
            if debug then
                file.write("No output at index " .. i)
            end
        end
    end

    file.close()

    return chickenStats
end

return stats
