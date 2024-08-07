--[[
https://github.com/tarantool/tarantool/issues/8887
]]

local datetime = require("datetime")
local msgpack = require("msgpack")
local luzer = require("luzer")

-- See https://www.tarantool.io/en/doc/latest/reference/reference_lua/datetime/interval_new/
local function new_itv(fdp)
    return {
        nsec      = fdp:consume_integer(math.min, math.max),
        usec      = fdp:consume_integer(math.min, math.max),
        msec      = fdp:consume_integer(math.min, math.max),
        sec       = fdp:consume_integer(math.min, math.max),
        min       = fdp:consume_integer(math.min, math.max),
        hour      = fdp:consume_integer(math.min, math.max),
        day       = fdp:consume_integer(math.min, math.max),
        week      = fdp:consume_integer(math.min, math.max),
        month     = fdp:consume_integer(math.min, math.max),
        year      = fdp:consume_integer(math.min, math.max),
        adjust    = fdp:consume_integer(math.min, math.max),
    }
end

local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)
    local itv = datetime.interval.new(new_itv(fdp))
    local ok, encoded_itv = pcall(msgpack.encode, itv)
    assert(ok)
    local res
    ok, res = pcall(msgpack.decode, encoded_itv)
    assert(ok)
    assert(itv == res)
end

local args = {
    print_pcs = 1,
    max_len = 4096,
    artifact_prefix = "msgpack_msgpack_itv_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
