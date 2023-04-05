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

if arg[1] then
    local fh = io.open(arg[1])
    local testcase = fh:read("*all")
    TestOneInput(testcase)
    os.exit()
end

local script_path = debug.getinfo(1).source:match("@?(.*/)")

local args = {
    max_len = 4096,
    dict = script_path .. "/tarantool-corpus/json_decode.dict",
    corpus = script_path .. "/tarantool-corpus/json_decode",
    artifact_prefix = "json_decode_",
    max_total_time = 60,
    print_final_stats = 1,
}
luzer.Fuzz(TestOneInput, nil, args)
