-- Author: Matthew Moore
-- File: main.lua
-- Brief: Lua file for handling the automation of breeding chickens.
-- Date: 01/27/2023
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

-- GLOBALS
local DEBUG = true
local STAT_COMPLETE_FILE = "statsComplete.json"
local STAT_ROOST_FILE = "statsRoost.json"

local function main()
    -- TODO Need to use something to calculate the position of the turtle and the move it to the absolute position of the breeder before calling this method
    local chickenBreeder = peripheral.wrap("front")

    local parentStats = stats.getStats(chickenBreeder, STAT_COMPLETE_FILE, "w", "parents", DEBUG)
    local offspringStats = stats.getStats(chickenBreeder, STAT_COMPLETE_FILE, "a", "offspring", DEBUG)

    local roostParentStats = stats.getRoostStats(parentStats, STAT_ROOST_FILE, "w", DEBUG)
    local roostoffspringStats = stats.getRoostStats(offspringStats, STAT_ROOST_FILE, "a", DEBUG)
end

main()
