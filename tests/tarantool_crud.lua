--[[
Testing CRUD operations in a box.space against a Lua table.

See:

- vinyl: provide long run stress-like testing
  https://github.com/tarantool/tarantool/issues/5076
- Tarantool Lua API: Submodule box.space
  https://www.tarantool.io/en/doc/latest/reference/reference_lua/box_space/
- QuickCheck helps debug Google LevelDB
  http://www.quviq.com/google-leveldb/
- Testing a database for race conditions with QuickCheck
  https://dl.acm.org/doi/10.1145/2034654.2034667
]]

local msgpack = require("msgpack")
local luzer = require("luzer")

local function setup()
    -- create a space.
    -- see vinyl.lua
end

local function TestOneInput(buf)
    -- local fdp = luzer.FuzzedDataProvider(buf)
    -- see vinyl.lua
end

local args = {
    print_pcs = 1,
    max_len = 4096,
    artifact_prefix = "tarantool_crud_",
    max_total_time = 60,
    print_final_stats = 1,
}
luzer.Fuzz(TestOneInput, nil, args)
