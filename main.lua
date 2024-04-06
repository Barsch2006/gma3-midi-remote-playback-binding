-- **********************************************************
-- ** I wanted to make some changes to the original plugin **
-- *********** by Lenschcode, so I forked it. ***************
-- ***************** Fork from Lenschcode *******************
-- **** https://github.com/lenschcode/MA3-Midi-Executors ****
-- **********************************************************

-- ************************ License *************************
-- ***** Licensed under GNU General Public License v3.0 *****
-- **********************************************************

local function checkExecutor(name)
    local exec = {}
    -- Executor <page>-<id> <type>
    exec.page, exec.id, exec.type = name:match("Executor (%d+)-(%d+) (%a+)")
    if exec.page and exec.id and exec.type == "Key" or exec.type == "Fader" then
        -- assign executor to the specified page
        return exec
    else
        -- assign executor to every page (the current one)
        exec.page = CurrentExecPage().no
        -- Executor <id> <type>
        exec.id, exec.type = name:match("Executor (%d+) (%a+)")

        if exec.page and exec.id and exec.type == "Key" or exec.type == "Fader" then
            return exec
        else
            return nil
        end
    end
end

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

local function parseMidiRemotes()
    for _, remote in pairs(Root().ShowData.Remotes.MIDIRemotes:Children()) do
        local exec = checkExecutor(remote.name)
        if exec ~= nil then
            if remote.target ~= getExecObject(exec.page, exec.id) then
                remote.target = getExecObject(exec.page, exec.id)
            end
            if remote.target == nil then
                if remote.key ~= "" then
                    remote.key = ""
                end
                if remote.fader ~= "" then
                    remote.fader = ""
                end
            else
                if exec.type == "Key" then
                    if remote.key ~= getExecKey(exec.page, exec.id) then
                        remote.key = getExecKey(exec.page, exec.id)
                    end
                    if remote.fader ~= "" then
                        remote.fader = ""
                    end
                else
                    if remote.key ~= "" then
                        remote.key = ""
                    end
                    if remote.fader ~= getExecFader(exec.page, exec.id) then
                        remote.fader = getExecFader(exec.page, exec.id)
                    end
                end
            end
        end
    end
end

local function main()
    parseMidiRemotes()
end

return main
