luaunit = require('luaunit')
manager = assert(loadfile("../files/sbin/spectrum_scan_manager.lua"))

TestRemoveDefaultWifi = {
}

function TestRemoveDefaultWifi.test_default()
    luaunit.assertNotNil(manager)
end

os.exit(luaunit.LuaUnit.run())
