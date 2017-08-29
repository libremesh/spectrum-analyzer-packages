#!/usr/bin/env lua

require "os"

luaunit = require('luaunit')
lib = require("files/usr/lib/lua/lib_spectrum")

TestBed = {
}

function TestBed.test_default()
    -- luaunit.assertNotFalse(lib)
end

function TestBed.test_no_interface_empty_list()
    lib.BASE_PATH = os.tmpname()
    os.execute("rm "..lib.BASE_PATH)
    os.execute("mkdir "..lib.BASE_PATH)
    luaunit.assertEquals(lib.get_interfaces(), {})
    os.execute("rmdir "..lib.BASE_PATH)
end

os.exit(luaunit.LuaUnit.run())

