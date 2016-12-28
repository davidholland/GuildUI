-- Global logger
local _, GuildUI=...

GuildUI.LoggingEnabled = false
GuildUI.Log = function (...)
    if GuildUI.LoggingEnabled then
        print(...)
    end
end