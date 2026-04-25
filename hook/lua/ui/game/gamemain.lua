local function ExistGlobal(name)
    return rawget(_G, name) ~= nil
end

local state = import('/mods/LiveMetrics/modules/exporter_state.lua')
if ExistGlobal "UMT" and UMT.Version >= 11 then

    local OriginalCreateUI = CreateUI
    function CreateUI(isReplay)

        OriginalCreateUI(isReplay)

        LOG("[FA_Metrics_Exporter] Loaded")

        local state = import('/mods/LiveMetrics/modules/exporter_state.lua')
        module = import('/mods/LiveMetrics/modules/exporter.lua')
        module.MapInfoExport()

        -- switch army for replay recording
        if isReplay and HasCommandLineArg("/switch-to-army") then
            local switchTo = GetCommandLineArg("/switch-to-army", 1)[1]
            LOG("FA_METRICS: Switch to army:" .. tostring(GetCommandLineArg("/switch-to-army", 1)[1]) .. " requested.")
            SetFocusArmy(tonumber(switchTo))
        end

        ForkThread(function()
            while true do

                if state.GetDisabledState() then
                    WaitSeconds(5)
                    continue
                end

                module.TickExporter()
                WaitSeconds(1)
            end
        end)

        ForkThread(function()
            WaitSeconds(5)
            state.PrintWarningIfHotkeyNotSet()
        end)
    end

else
    local OriginalCreateUI = CreateUI
    function CreateUI(isReplay)

        OriginalCreateUI(isReplay)
        local state = import('/mods/LiveMetrics/modules/exporter_state.lua')
        string = "UI Mod Tools is not active/installed. FA Metrics Exporter will not work!"
        state.PrintWarningIngame(string)

    end
    WARN("FA_Metrics requires UI MOD TOOLS Version 11 or higher")
end
