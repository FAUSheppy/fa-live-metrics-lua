local function ExistGlobal(name)
    return rawget(_G, name) ~= nil
end

if ExistGlobal "UMT" and UMT.Version >= 11 then

    local OriginalCreateUI = CreateUI
    function CreateUI(isReplay)

        OriginalCreateUI(isReplay)

        LOG("[FA_Metrics_Exporter] Loaded")

        module = import('/mods/fa-live-metrics/modules/exporter.lua')
        state = import('/mods/fa-live-metrics/modules/exporter_state.lua')
        module.MapInfoExport()

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
    WARN("FA_Metrics requires UI MOD TOOLS Version 11 or higher")
end
