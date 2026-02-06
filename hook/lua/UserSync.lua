local function table_empty(t)
    if type(t) ~= 'table' then return true end
    return next(t) == nil
end

local json = import('/mods/LiveMetrics/modules/json.lua')
local originalOnSyncFAMetrics = OnSync
function OnSync()
    originalOnSyncFAMetrics()

    if Sync.Events and Sync.Events.ACUDestroyed then
        local acu_destroyed_info = {
            time = GetGameTimeSeconds(),
            destroyed = Sync.Events.ACUDestroyed
        }
        LOG("WTF LOLOLOL")
        LOG("WTF LOLOLOL")
        LOG("WTF LOLOLOL")
        LOG("WTF LOLOLOL")
        LOG("WTF LOLOLOL")
        LOG("WTF LOLOLOL")
        LOG("WTF LOLOLOL")
        LOG("[FA_METRICS] JSON: " .. json.encode(acu_destroyed_info))
    end 

    if not table_empty(Sync.Score) then
        -- TODO
    end

end
