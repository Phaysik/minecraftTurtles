local stats = {}

function stats.getStats(peripheral, outputFile)
    local file = fs.open(outputFile, "w")

    for i = 4, 6 do
        if peripheral.getItemMeta(i) then
            file.write(textutils.serialize(peripheral.getItemMeta(i)))
        else
            file.write("No output at index " .. i)
        end
    end

    file.close()
end

return stats
