-- https://github.com/tarantool/tarantool/issues/4366
-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/json/

local json = require("json")
local luzer = require("luzer")
local math = require("math")

local function TestOneInput(buf)
    local ok, obj = pcall(json.decode, buf)
    if obj == math.inf or
       obj == 0/0 then
        return -1
    end
    if ok == true then
        assert(json.encode(obj) ~= nil)
    end
end

local args = {
    max_len = 4096,
    artifact_prefix = "json_decode_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
