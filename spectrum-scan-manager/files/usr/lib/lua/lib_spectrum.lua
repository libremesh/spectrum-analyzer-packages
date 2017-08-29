#!/usr/bin/env lua

require "io"

local WIRELESS_INTERFACES_COMMAND =  "iw dev | grep -B1 Interface | tr -d \\# | tr '\\n' '\\t' | sed s/Interface//g | xargs | sed 's/-- /\\n/g' | cut -f 2 -d\\ "

function explode(delimiter, s)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- Extracted from https://github.com/nicoechaniz/lime-ubus/commit/f7e462c4722f9a5f4ad84e59a7f912b27e8abd8a#diff-27f476dd2d5937c30c6366eecbd6a5afR38
local function shell(command)
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()
    return result
end

lib = {}

-- Converts from wireless interface name to phy. Returns empty if no match
local function phy_from_wname(wname)
    return shell( WIRELESS_INTERFACES_COMMAND.." | awk '$1 == \""..wname.."\" {print $2}'" )
end

function getn (t)
  if type(t.n) == "number" then return t.n end
  local max = 0
  for i, _ in pairs(t) do
    if type(i) == "number" and i>max then max=i end
  end
  return max
end

function lib.run_scan(dev)
    local results, phy

    phy = phy_from_wname(dev)

    shell( "echo 0 > /sys/kernel/debug/ieee80211/"..phy.."/ath9k*/fft_period" )
    shell( "echo 0 > /sys/kernel/debug/ieee80211/"..phy.."/ath9k*/ss_short_rpt" )
    shell( "echo chanscan > /sys/kernel/debug/ieee80211/"..phy.."/ath9k*/spectral_scan_ctl" )
    shell( "iw dev "..dev.." scan" )
    results = shell( "cat /sys/kernel/debug/ieee80211/"..phy.."/ath9k*/spectral_scan0" )
    shell( "echo disable > /sys/kernel/debug/ieee80211/"..phy.."/ath9k*/spectral_scan_ctl" )

    return results
end

function lib.get_interfaces()
    return explode('\n', shell( WIRELESS_INTERFACES_COMMAND ))
end

print(shell( WIRELESS_INTERFACES_COMMAND ))

-- return lib
