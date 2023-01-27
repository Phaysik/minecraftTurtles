http.request("https://github.com/Phaysik/minecraftTurtles/") -- Where all lua scripts are hosted

local requesting = true

local debug = false

local file = fs.open("siteInfo.json", "w")

while requesting do
    ---@diagnostic disable-next-line: undefined-field
    local statusCode, url, sourceText = os.pullEvent()

    if statusCode == "http_success" then
        local line = sourceText.readLine()

        local files = {}

        while line do -- Loop through all lines returned by the request
            if string.find(line, ".lua") then
                local regex = "a\">.*.lua" -- Get a\">[fileName].lua from any line that has a .lua
                local fileName = ""
                for token in string.gmatch(line, regex) do
                    fileName = string.sub(token, 4) -- Remove the a\"> from the string

                    if debug then
                        print(fileName)
                    end
                end

                table.insert(files, fileName) -- Compile list of all files
                line = sourceText.readLine()
            else
                line = sourceText.readLine()
            end
        end

        sourceText.close()

        if debug then
            file.write(textutils.serialize(files))
        end

        for _, value in pairs(files) do -- Loop through all lua files
            local concatenation = "https://raw.githubusercontent.com/Phaysik/minecraftTurtles/master/" .. value -- Get the raw data of the lua files

            if debug then
                file.write(value)
                print(concatenation)
            end

            local request = http.get(concatenation).readAll() -- Read all lines of the lua file

            if request then
                local scriptFile = fs.open(value, "w")

                scriptFile.write(request)

                scriptFile.close()

                print("File: " .. value .. " downloaded successfully")
            else
                print("File: " .. value .. " not found")
            end
        end

        file.close()

        requesting = false
    elseif statusCode == "http_failure" then
        print("Request failed")

        requesting = false
    end
end
