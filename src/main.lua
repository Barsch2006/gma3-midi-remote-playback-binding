local function getExecKey(page, id)
    local exec = ObjectList("page " .. page .. "." .. id)[1]

    if exec ~= nil then
        return exec.key
    else
        return nil
    end
end

local function getExecFader(page, id)
    local exec = ObjectList("page " .. page .. "." .. id)[1]

    if exec ~= nil then
        return exec.fader
    else
        return nil
    end
end

local function getExecObject(page, id)
    local exec = ObjectList("page " .. page .. "." .. id)[1]

    if exec ~= nil then
        return exec.object
    else
        return nil
    end
end

local function parseRemoteNote(note)
    local parsed = {}
    parsed.type, parsed.page, parsed.id, parsed.exec_type = note:match("(%a+) (%d+)-(%d+) (%a+)")
    if parsed.type and parsed.page and parsed.id and (parsed.exec_type == "Key" or parsed.exec_type == "Fader") then
        return parsed
    else
        parsed.page = CurrentExecPage().no
        parsed.type, parsed.id, parsed.exec_type = note:match("(%a+) (%d+) (%a+)")
        if (parsed.type == "Exec" or parsed.type == "XKey") and parsed.page and parsed.id and (parsed.exec_type == "Key" or parsed.exec_type == "Fader") then
            return parsed
        else
            return nil
        end
    end
end

local function main()
    for _, remote in pairs(Root().ShowData.Remotes.MIDIRemotes:Children()) do
        local parsed = parseRemoteNote(remote.note)
        if (parsed ~= nil) then
            -- set the target
            if remote.target ~= getExecObject(parsed.page, parsed.id) then
                remote.target = getExecObject(parsed.page, parsed.id)
            end

            -- set the key/ fader
            if parsed.exec_type == "Key" then
                -- set the key and clear the fader
                if remote.target ~= getExecKey(parsed.page, parsed.id) then
                    remote.target = getExecKey(parsed.page, parsed.id)
                end
                remote.fader = ""
            else
                -- set the fader and clear the key
                if remote.target ~= getExecFader(parsed.page, parsed.id) then
                    remote.target = getExecFader(parsed.page, parsed.id)
                end
                remote.key = ""
            end
        end
    end
end

return main;
