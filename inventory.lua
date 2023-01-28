-- Author: Matthew Moore
-- File: inventory.lua
-- Brief: Lua file for handling the turtles inventory management.
-- Date: 01/28/2023
-- Version: 1.0

-- IMPORTS
local globals = require("globals.lua")

local inventory = {}

inventory["inventory"] = {}

function inventory.fillInventoryTable()
    local file = fs.open(globals.INVENTORY_INFORMATION_FILE, "w") -- Debug file
    for i = 1, globals.INVENTORY_AMOUNT do
        inventory["inventory"][i] = turtle.getItemDetail(i)
        if globals.DEBUG then
            file.write("Position " .. i .. ": " .. textutils.serialize(inventory["inventory"][i]) .. "\n")
        end
    end

    file.close()
end

function inventory.updateInventoryPosition(position)
    inventory.inventory[position] = turtle.getItemMeta(position)
    if globals.DEBUG then
        local file = fs.open(globals.INVENTORY_INFORMATION_FILE, "w") -- Debug file
        for i = 1, globals.INVENTORY_AMOUNT do
            inventory["inventoy"][i] = turtle.getItemDetail(i)

            file.write("Position " .. i .. ": " .. textutils.serialize(inventory["inventory"][i]) .. "\n")
        end

        file.close()
    end
end

function inventory.getPositionOfXInARow(count)
    inventory.fillInventoryTable()

    local inARow = 0

    local file = fs.open(globals.INVENTORY_ITEM_COUNT_FILE, "w") -- Debug file
    -- We will assume the first position is always holding the turle's fuel
    for i = 2, globals.INVENTORY_AMOUNT do
        local amount = turtle.getItemCount(i)

        if globals.DEBUG then
            file.write(textutils.serialize(turtle.getItemMeta(i)) .. "\n")
        end

        if amount == 0 then
            inARow = inARow + 1

            if inARow == count then
                if globals.DEBUG then
                    file.write("Starting index of " .. count .. " empty positions is: " .. i - 2)
                end

                file.close()
                return i - 2
            end
        else
            inARow = 0
        end
    end

    if globals.DEBUG then
        file.write("Starting index of " .. count .. " empty positions is: " .. -1)
    end

    file.close()

    return -1 -- Will return -1 for no X positions open in a row
end

function inventory.moveItemsToStart()
    local file = fs.open(globals.INVENTORY_MOVE_FILE, "w") -- Debug file
    local backPointer = globals.INVENTORY_AMOUNT
    -- Assuming that the turtles fuel is in slot one
    local frontPointer = 2

    -- Loop until the back slot and the front slot are the same
    while backPointer ~= frontPointer do
        turtle.select(backPointer)

        if globals.DEBUG then
            file.write("Compare Result: " .. tostring(turtle.compareTo(3)))
        end

        if turtle.getItemCount(frontPointer) == 0 or turtle.compareTo(frontPointer) then -- If not item at the front pointer slot or they are the same item, then transfer
            turtle.transferTo(frontPointer)

            inventory.updateInventoryPosition(frontPointer)
            inventory.updateInventoryPosition(backPointer)

            backPointer = backPointer - 1 -- Move the back slot to the left

            if globals.DEBUG then
                file.write("\nTransfered from position: " .. backPointer .. " to position: " .. frontPointer .. "\n")
            end
        elseif turtle.getItemCount(backPointer) == 0 then
            backPointer = backPointer - 1 -- If there are no items in the back slot, then move it to the left
        else
            frontPointer = frontPointer + 1 -- If an item on the front slot and it's not the same as the back slot, move the front slot to the right

            if globals.DEBUG then
                file.write("\nTransfer failed: Items not the same\n")
            end
        end

    end

    file.close()
end

function inventory.forceMoveToGetXInARow(count)
    local XInARow = inventory.getPositionOfXInARow(count)

    -- TODO This can infinitely loop if there are too many unique items in the turtles inventory
    -- Perhaps put all items, aside from fuel, in a chest and proceed with required function before getting them back from the chest
    while XInARow == -1 do
        inventory.moveItemsToStart()

        XInARow = inventory.getPositionOfXInARow(count)
    end

    return XInARow
end

return inventory
