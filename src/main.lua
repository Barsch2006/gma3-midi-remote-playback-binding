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
    parsed.page, parsed.id, parsed.exec_type = note:match("Target: (%d+).(%d+) (%a+)")
    if parsed.page and parsed.id and (parsed.exec_type == "Key" or parsed.exec_type == "Fader") then
        return parsed
    else
        parsed.page = CurrentExecPage().no
        parsed.id, parsed.exec_type = note:match("Target: (%d+) (%a+)")
        if parsed.page and parsed.id and (parsed.exec_type == "Key" or parsed.exec_type == "Fader") then
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
                if remote.key ~= getExecKey(parsed.page, parsed.id) then
                    remote.key = getExecKey(parsed.page, parsed.id)
                end
                remote.fader = ""
            else
                -- set the fader and clear the key
                if remote.fader ~= getExecFader(parsed.page, parsed.id) then
                    remote.fader = getExecFader(parsed.page, parsed.id)
                end
                remote.key = ""
            end

            if CurrentExecPage().no == tonumber(parsed.page) then
                remote.enabled = true
            else
                remote.enabled = false
            end
        end
    end
end

return main;
