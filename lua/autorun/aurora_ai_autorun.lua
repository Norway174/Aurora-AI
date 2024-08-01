AURORA = AURORA or {}
AURORA.AI = AURORA.AI or {} 

local loadFolders = {
    "aurora_ai", -- Main Folder
}

local fonts = {
}

function AURORA.MsgC( ... )
    local args = {...}

    local message_table = {}

    if SERVER then
        table.insert(message_table, Color(52, 160, 211))
        table.insert(message_table, "[AURORA_AI-SV] ")
    end
    if CLIENT then
        table.insert(message_table, Color(52, 211, 78))
        table.insert(message_table, "[AURORA_AI-CL] ")
    end

    table.insert(message_table, Color(255, 255, 255))
    table.Add(message_table, args)
    table.insert(message_table, Color(198, 52, 211))
    table.insert(message_table, " ["..os.date('%Y-%m-%d %H:%M:%S').."]\n")

    MsgC(unpack(message_table))
end

function AURORA.LoadAllFile(fileDir)
    local files, dirs = file.Find(fileDir .. "*", "LUA")
    
    for _, subFilePath in ipairs(files) do
        if (string.match(subFilePath, ".lua", -4) and not ignoreFiles[subFilePath]) then
            
            local fileRealm = string.sub(subFilePath, 1, 2)

            if SERVER and (fileRealm != "sv" or fileRealm == "sh") then
                AURORA.MsgC("Adding CSLuaFile File " .. fileDir .. subFilePath)
                AddCSLuaFile(fileDir .. subFilePath)
            end

            if CLIENT and (fileRealm != "sv" or fileRealm == "sh") then
                AURORA.MsgC("Including File " .. fileDir .. subFilePath)
                include(fileDir .. subFilePath)
            elseif SERVER and (fileRealm == "sv" or fileRealm == "sh") then
                AURORA.MsgC("Including File " .. fileDir .. subFilePath)
                include(fileDir .. subFilePath)
            end

        end
    end

    for _, dir in ipairs(dirs) do
        AURORA.LoadAllFile(fileDir .. dir .. "/")
    end
end

function AURORA.LoadAllFonts()
    if SERVER and istable( fonts ) then

    for _, f in pairs( fonts ) do
        local src = string.format( 'resource/fonts/%s', f )
        AURORA.MsgC("Loading font: " .. src)
        resource.AddSingleFile( src )
        AURORA.MsgC("Successfully loaded font: " .. src)
    end

    end
end

function AURORA.LoadAllFiles()
    if not istable( loadFolders ) then return end

    for _, f in pairs( loadFolders ) do
        f = f .. "/"
        AURORA.MsgC("Loading folder: " .. f)
        AURORA.LoadAllFile(f)
        AURORA.MsgC("Successfully loaded folder: " .. f)
    end

end

AURORA.MsgC(Color(255,100,0), "---- AURORA AI LOADING ----")
AURORA.LoadAllFonts()
AURORA.LoadAllFiles()
AURORA.MsgC(Color(255,100,0), "---- AURORA AI END ----")
