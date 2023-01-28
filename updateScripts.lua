-- Author: Matthew Moore
-- File: updateScripts.lua
-- Brief: Lua file for creating an update script.
-- Details: Allows the user to download all lua files located in their github repository at once
-- Date: 01/28/2023
-- Version: 1.0

local githubName = "Phaysik"
local repositoryName = "minecraftTurtles" -- The repository must be public for this script to work
local devBranch = "master"

local headers = {
    ["cache-control"] = "no-store, no-cache, max-age=5, must-revalidate",
    ["Cache-Control"] = "no-store, no-cache, max-age=5, must-revalidate",
}

local repoRequest = http.get("https://github.com/" .. githubName .. "/" .. repositoryName .. "/", headers) -- Where all lua scripts are hosted

local debug = false

local file = fs.open("Debug/siteInfo.json", "w") -- Debug file

if repoRequest then
    local line = repoRequest.readLine()

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
            line = repoRequest.readLine()
        else
            line = repoRequest.readLine()
        end
    end

    repoRequest.close()

    if debug then
        file.write(textutils.serialize(files))
    end

    for _, value in pairs(files) do -- Loop through all lua files
        if value ~= "" then -- Ignore the empty filename that is somehow added
            local concatenation = "https://raw.githubusercontent.com/" ..
                githubName .. "/" .. repositoryName .. "/" .. devBranch .. "/" .. value -- Get the raw data of the lua files

            if debug then
                file.write(value)
            end

            local request = http.get(concatenation, headers)

            if request then
                local content = request.readAll() -- Read all lines in the lua file

                local scriptFile = fs.open(value, "w")

                scriptFile.write(content)

                scriptFile.close()

                print("File: " .. value .. " downloaded successfully")
            else
                print("File: " .. value .. " not found")
            end
        end
    end

    file.close()

end
