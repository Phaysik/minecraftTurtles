http.request("https://github.com/Phaysik/minecraftTurtles/")

local requesting = true

local file = fs.open("siteInfo.json", "w")

while requesting do
    ---@diagnostic disable-next-line: undefined-field
    local statusCode, url, sourceText = os.pullEvent()

    if statusCode == "http_success" then
        local line = sourceText.readLine()

        local data = {}

        local getNext = false
        
        while line do
            if string.find(line, "role=\"rowheader\"") then
                getNext = true
            else
                if getNext then
                    table.insert(data, line)
                    line = sourceText.readLine()
                end
                line = sourceText.readLine()
            end

        end

        sourceText.close()
        -- print(respondedText)
        file.write(textutils.serialize(data))

        file.close()

        requesting = false
    elseif statusCode == "http_failure" then
        print("Request failed")

        requesting = false
    end
end
