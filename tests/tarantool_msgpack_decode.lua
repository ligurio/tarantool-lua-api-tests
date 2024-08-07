--[[
https://github.com/tarantool/tarantool/issues/5184
https://github.com/tarantool/tarantool/issues/4724
https://github.com/tarantool/tarantool/issues/3900
https://github.com/tarantool/tarantool/issues/5014 "\xd4\x02\x00"
https://github.com/tarantool/tarantool/issues/5016 "\xd4\xfe\x00"
https://github.com/tarantool/tarantool/issues/5017 "\xd4\x0f\x00"
https://github.com/tarantool/tarantool/issues/206

https://www.tarantool.io/ru/doc/latest/reference/reference_lua/msgpack/
]]

local msgpack = require("msgpack")
local luzer = require("luzer")

local function TestOneInput(buf)
    local ok, res = pcall(msgpack.decode, buf)
    if ok == true then
        ok, res = pcall(msgpack.encode, res)
        if ok == false and
           string.find(res, "Too high nest level") then
            return -1
        end
        assert(ok == true)
        assert(res ~= nil)
    end
end

local args = {
    print_pcs = 1,
    max_len = 4096,
    artifact_prefix = "msgpack_decode_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
