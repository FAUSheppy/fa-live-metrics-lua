local orig_initReclaimGroup = InitReclaimGroup
local json = import('/mods/LiveMetrics/modules/json.lua')

function InitReclaimGroup(view)
  orig_initReclaimGroup(view)

  -- this is a lot of data we need to prefilter it
  local game_time_min = GetGameTimeSeconds() * 60
  local reclaim_filtered = Reclaim
  if game_time_min < 10 then
    -- export only > 10
  elseif game_time_min >= 10 and game_time_min <= 15 then
    -- export only > 100
  else
    -- export only > 500
  end
  
  -- build result
  -- TODO maybe convert floats to space bandwith on disk
  ret = {
    time = GetGameTimeSeconds(),
    mapRecaimInfo = reclaim_filtered,
    armyId = GetFocusArmy(),
  }

  LOG("[FA_METRICS] JSON: " .. json.encode(ret))

end