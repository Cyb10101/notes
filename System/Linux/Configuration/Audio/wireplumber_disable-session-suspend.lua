-- Configure audio suspend
-- If you didn't hear a notification or a video delayed playing the sound, it's because the audio device is going into power saving mode.
-- Filename: ~/.config/wireplumber/main.lua.d/disable-session-suspend.lua
-- ln -sr ~/Sync/notes/System/Linux/Configuration/Audio/wireplumber_disable-session-suspend.lua ~/.config/wireplumber/main.lua.d/disable-session-suspend.lua

-- Restart for changes to take effect
-- systemctl --user restart pipewire wireplumber

-- Show if audio device suspended
-- sudo apt install pulseaudio-utils
-- watch -c -n 0.1 "pactl list short sinks"
-- watch -c -n 0.1 "pactl list short sinks | sed -E -e 's/(SUSPENDED)/\x1b[31m\1\x1b[0m/g' -e 's/(IDLE)/\x1b[33m\1\x1b[0m/g' -e 's/(RUNNING)/\x1b[32m\1\x1b[0m/g'"

table.insert (alsa_monitor.rules, {
    matches = {
      {
        -- Matches all sources
        { "node.name", "matches", "alsa_input.*" },
      },
      {
        -- Matches all sinks
        { "node.name", "matches", "alsa_output.*" },
      },
    },
    apply_properties = {
      --["session.suspend-timeout-seconds"] = 0, -- Disables suspend, on some systems this won't work and you need to set a high value instead
      --["session.suspend-timeout-seconds"] = 86400, -- 1 Day
      --["session.suspend-timeout-seconds"] = 3600, -- 1 Hour
      ["session.suspend-timeout-seconds"] = 600, -- 10 Minutes
    },
})
