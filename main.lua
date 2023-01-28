-- Author: Matthew Moore
-- File: main.lua
-- Brief: Lua file for handling the automation of breeding chickens.
-- Date: 01/28/2023
-- Version: 1.0

-- START CODE STEALING
local require

do
    local requireCache = {}

    require = function(file)
        local absolute = shell.resolve(file)

        if requireCache[absolute] ~= nil then
            --# Lucky day, this file has already been loaded once!
            --# Return its cached result.
            return requireCache[absolute]
        end

        --# Create a custom environment so that loaded
        --# source files also have access to require.
        local env = {
            require = require
        }

        setmetatable(env, { __index = _G, __newindex = _G })

        --# Load the source file with loadfile, which
        --# also allows us to pass our custom environment.
        ---@diagnostic disable: param-type-mismatch
        local chunk, err = loadfile(absolute, env)

        --# If chunk is nil, then there was a syntax error
        --# or the file does not exist.
        if chunk == nil then
            return error(err)
        end

        --# Execute the file, cache and return its return value.
        local result = chunk()
        requireCache[absolute] = result
        return result
    end
end
-- END CODE STEALING

-- IMPORTS
local stats = require("checkStats.lua")
local turtleController = require("turtle.lua")
local globals = require("globals.lua")

local function main()
    -- TODO Need to use something to calculate the position of the turtle and the move it to the absolute position of the breeder before calling this method
    local chickenBreeder = peripheral.wrap("front")

    local parentStats = stats.getStats(chickenBreeder, globals.STAT_COMPLETE_FILE, "w", "parents", globals.DEBUG)
    local offspringStats = stats.getStats(chickenBreeder, globals.STAT_COMPLETE_FILE, "a", "offspring", globals.DEBUG)

    -- TODO Get the earliest open spots in the turtles inventory and then pass it to the getRoostStats function, and make sure that there are three open slots in a row, in the case of three different ofsspring
    local threeInARowPosition = turtleController.inventory.forceMoveToGetXInARow(3, globals.INVENTORY_ITEM_COUNT_FILE,
        globals.INVENTORY_MOVE_FILE, globals.DEBUG)

    local roostoffspringStats = stats.getRoostStats(offspringStats, globals.STAT_ROOST_FILE, "w", "offspring", 1,
        globals.DEBUG)
    -- TODO Get the earliest open spots in the turtles inventory and and make sure that there are two open slots in a row, for both parents
    -- TODO Test to make sure that the seeds will not end up in the parent's spots
    local roostParentStats = stats.getRoostStats(parentStats, globals.STAT_ROOST_FILE, "a", "parents", 1, globals.DEBUG)

    -- TODO get the two highest stats from the offspring stats and then compare against the parent stats
end

main()
