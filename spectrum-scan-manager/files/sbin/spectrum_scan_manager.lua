#!/usr/bin/env lua

require "ubus"
require "uloop"

require "lib_spectrum"

local ubus_objects = {
    spectral_scan_manager = {
        scan = lib_spectrum.run_scan,
        get_interfaces = lib_spectrum.get_interfaces
    }
}

uloop.init()

local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubus")
end

conn:add( ubus_objects )

uloop.run()
