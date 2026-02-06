local json = import('/mods/LiveMetrics/modules/json.lua')

local positionMarkers = import("/lua/ui/game/worldview.lua").positionMarkers
local EnhancementQueueFile = import("/lua/ui/notify/enhancementqueue.lua")

local function GetFactoryForQueueDisplay()
    local selection = GetSelectedUnits()
    if not selection then return nil end
    local factory
    for _, unit in selection do
        if EntityCategoryContains(categories.FACTORY, unit) then
            if not factory then
                factory = unit
            else
                if unit:GetBlueprint().BlueprintId ~= factory:GetBlueprint().BlueprintId then
                    return nil
                end
            end
        end
    end
    return factory
end

local function CollectEconomy()

    local econ = GetEconomyTotals()
    local simFrequency = GetSimTicksPerSecond()
    local armiesTable = GetArmiesTable().armiesTable
    local currentArmy = armiesTable[GetFocusArmy()]

    econ.lastUseActual["MASS"] = econ.lastUseActual["MASS"] * simFrequency
    econ.lastUseRequested["MASS"] = econ.lastUseRequested["MASS"] * simFrequency
    econ.lastUseActual["ENERGY"] = econ.lastUseActual["ENERGY"] * simFrequency
    econ.lastUseRequested["ENERGY"] = econ.lastUseRequested["ENERGY"] * simFrequency

    
    econ.income["MASS_RAW"] = econ.income["MASS"] * 10
    econ.income["ENERGY_RAW"] = econ.income["ENERGY"] * 10

    econ.income["MASS"] = currentArmy.eco["massIncome"]
    econ.income["ENERGY"] = currentArmy.eco["engyIncome"]

    
    econ["OUT_OF_GAME"] = currentArmy.outOfGame
    econ["armyId"] = GetFocusArmy()
    econ["BUILD_POWER_TOTAL"] = currentArmy.eco["buildPowerTotal"]
    econ["BUILD_POWER_USED"] = currentArmy.eco["buildPowerUsed"]

    -- LOG("[FA_METRICS] JSON: " .. tostring(currentArmy.eco["buildPowerTotal"]))
    -- LOG("[FA_METRICS] JSON: " .. tostring(currentArmy.eco["massIncome"]))

    local teamEcoMass = 0
    local teamMatesCount = 0
    for armyIndex, army in pairs(armiesTable) do
        if armyIndex == GetFocusArmy() or army.eco.massIncome == nil then
            continue
        end
        
        teamMatesCount = teamMatesCount + 1
        teamEcoMass = teamEcoMass + army.eco.massIncome
    end

    if teamMatesCount > 0 then
        econ["AVERAGE_TEAM_MASS_INCOME"] = teamEcoMass / teamMatesCount
    else
        econ["AVERAGE_TEAM_MASS_INCOME"] = 0
    end
        return econ
    end

local GetUnits = UMT.Units.GetFast
local function ProcessAllUnits()
    local allunits = GetUnits()
    local result = {}

    
    local currentlySelectedFactory = GetFactoryForQueueDisplay()
    for _, unit in allunits do

        local builder = nil
        if unit.originalBuilder ~= nil then
            builder = unit.originalBuilder:GetUnitId()
        end

        if IsDestroyed(unit) then
            continue
        end

        local entityId = unit:GetEntityId()
        local factoryQueue = SetCurrentFactoryForQueueDisplay(unit)
        local commandQueue = unit:GetCommandQueue()
        local enhancementQueue = EnhancementQueueFile.getEnhancementQueue()[entityId]
        
        --local reclaim = import('/lua/ui/game/reclaim.lua').reclaimDataPool 
        --LOG("[FA_METRICS] reclaim fields: " .. json.encode(reclaim))

        local focus = unit:GetFocus()
        local focusEntityId = nil
        if focus ~= nil then
            focusEntityId = focus:GetEntityId()
        end

        -- LOG("[FA_METRICS] unit:GetFocus(): " .. tostring(entityId) .. "->" .. json.encode(focusEntityId))

        table.insert(result, {
            ["entityId"]     = entityId,
            ["army"]         = unit:GetArmy(),
            ["unitId"]       = unit:GetUnitId(),
            ["percentBuilt"] = unit:GetFractionComplete(),
            ["unitFocus"]    = focusEntityId,
            ["x-pos"]        = string.format("%.3f", unit:GetPosition().x),
            ["y-pos"]        = string.format("%.3f", unit:GetPosition().y),
            ["z-pos"]        = string.format("%.3f", unit:GetPosition().z),
            ["maxHealth"]    = unit:GetMaxHealth(),
            ["currentHealth"]= string.format("%.0f", unit:GetHealth()),
            ["percentShield"]= unit:GetShieldRatio(),
            ["isPaused"]     = GetIsPaused({unit}),
            ["isIdle"]       = unit:IsIdle(),
            ["veterancy"]    = unit:GetStat("VetExperience", 0).Value,
            ["unitName"]     = unit:GetStat("UnitName", "no_unit_name").Value,
            ["factoryQueue"] = factoryQueue,
            ["commandQueue"] = commandQueue,
            ["enhancementQueue"] = enhancementQueue,
            ["isRepeatQueue"] = unit:IsRepeatQueue()
        })
    end
    ClearCurrentFactoryForQueueDisplay()
    if currentlySelectedFactory ~= nil then
        SetCurrentFactoryForQueueDisplay(currentlySelectedFactory)
    end

    return result
end

local function BuildPayload()
    
    
    local sessionInfo = SessionGetScenarioInfo()
    local econData = CollectEconomy()

    local camera = GetCamera("WorldCamera")
    local zoomRaw = camera:GetZoom()
    -- fully zoome out is approx zoomRaw/mapSizeY = 125-130, anything above 100 views the entire map
    local zoomNormalized = math.floor(zoomRaw*100/sessionInfo.size[1])

    return {
        time = GetGameTimeSeconds(),
        economy = econData,
        playerUnits = ProcessAllUnits(),
        cameraZoom = zoomNormalized,
        armyId = GetFocusArmy(),
        -- armiesTable = GetArmiesTable().armiesTable,
        -- visibleEnemies = CollectVisibleEnemies(),
    }
end

function TickExporter()
    local data = BuildPayload()
    LOG("[FA_METRICS] JSON: " .. json.encode(data))
end

function MapInfoExport()
    local sessionInfo = SessionGetScenarioInfo()
    local map_data = {
        mapName = sessionInfo.name,
        mapVersion = sessionInfo.map_version,
        mapSizeX = sessionInfo.size[1],
        mapSizeY = sessionInfo.size[2],
        ratings = sessionInfo.Options.Ratings,
        isUnranked = sessionInfo.Options.Unranked,
        armiesTable = GetArmiesTable().armiesTable,
        submitterArmyId = GetFocusArmy(),
        modVersion = 6,
    }
    LOG("[FA_METRICS] JSON: " .. json.encode(map_data))
    -- LOG("[FA_METRICS] JSON: " .. json.encode(sessionInfo))
end