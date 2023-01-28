-- Author: Matthew Moore
-- File: inventory.lua
-- Brief: Lua file for handling the turtles inventory management.
-- Date: 01/28/2023
-- Version: 1.0

local inventory = {}

function inventory.getPositionOfXInARow(count, outputFile, debug)
    local inventoryAmount = 16
    local inARow = 0

    local file = fs.open(outputFile, "w") -- Debug file
    -- We will assume the first position is always holding the turle's fuel
    for i = 2, inventoryAmount do
        local amount = turtle.getItemCount(i)

        if debug then
            local itemInfo = { ["Item Detail"] = textutils.serialize(turtle.getItemDetail(i)), ["Amount"] = amount }

            file.write(textutils.serialize(itemInfo) .. "\n")
        end

        if amount == 0 then
            inARow = inARow + 1

            if inARow == count then
                if debug then
                    file.write("Starting index of " .. count .. " empty positions is: " .. i - 2)
                end

                file.close()
                return i - 2
            end
        else
            inARow = 0
        end
    end

    if debug then
        file.write("Starting index of " .. count .. " empty positions is: " .. -1)
    end

    file.close()

    return -1 -- Will return -1 for no X positions open in a row
end

function inventory.moveItemsToStart(outputFile, debug)
    local file = fs.open(outputFile, "w") -- Debug file
    local inventoryAmount = 16
    local backPointer = inventoryAmount
    -- Assuming that the turtles fuel is in slot one
    local frontPointer = 2

    -- Loop until the back slot and the front slot are the same
    while backPointer ~= frontPointer do
        turtle.select(backPointer)

        if debug then
            file.write("Compare Result: " .. tostring(turtle.compareTo(3)))
        end

        if turtle.getItemCount(frontPointer) == 0 or turtle.compareTo(frontPointer) then -- If not item at the front pointer slot or they are the same item, then transfer
            turtle.transferTo(frontPointer)

            backPointer = backPointer - 1 -- Move the back slot to the left

            if debug then
                file.write("\nTransfered from position: " .. backPointer .. " to position: " .. frontPointer .. "\n")
            end
        elseif turtle.getItemCount(backPointer) == 0 then
            backPointer = backPointer - 1 -- If there are no items in the back slot, then move it to the left
        else
            frontPointer = frontPointer + 1 -- If an item on the front slot and it's not the same as the back slot, move the front slot to the right

            if debug then
                file.write("\nTransfer failed: Items not the same\n")
            end
        end

    end

    file.close()
end

function inventory.forceMoveToGetXInARow(count, item_count_output_file, item_move_output_file, debug)
    local XInARow = inventory.getPositionOfXInARow(count, item_count_output_file, debug)

    while XInARow == -1 do
        inventory.moveItemsToStart(item_move_output_file, debug)

        XInARow = inventory.getPositionOfXInARow(count, item_count_output_file, debug)
    end

    return XInARow
end

return inventory
