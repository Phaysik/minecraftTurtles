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
    local frontPointer = 2

    -- Assuming that the turtles fuel is in slot one
    for i = inventoryAmount, 2, -1 do
        turtle.select(i)

        if debug then
            file.write("Compare Result: " .. tostring(turtle.compareTo(3)))
        end

        if turtle.getItemCount(frontPointer) == 0 or turtle.compareTo(frontPointer) then
            turtle.transferTo(frontPointer)

            if debug then
                file.write("\nTransfered from position: " .. i .. " to position: " .. frontPointer)
            end
        else
            if debug then
                file.write("\nTransfer failed: Items not the same")
            end
        end

        frontPointer = frontPointer + 1
    end

    file.close()
end

return inventory
