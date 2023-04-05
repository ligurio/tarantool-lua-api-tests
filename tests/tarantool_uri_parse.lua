-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/uri/

local uri = require("uri")
local luzer = require("luzer")

local function TestOneInput(buf)
    local url = uri.parse(buf)
    if type(url) == "table" and
        url ~= nil then
        local str = uri.format(url)
        assert(str)
    end
end

if arg[1] then
    local testcase = io.open(arg[1]):read("*all")
    TestOneInput(testcase)
    print(arg[1])
    os.exit()
end

local script_path = debug.getinfo(1).source:match("@?(.*/)")

local args = {
    max_len = 1024,
    corpus = script_path .. "tarantool-corpus/uri_parse",
    artifact_prefix = "uri_parse_",
    max_total_time = 60,
    print_final_stats = 1,
}
luzer.Fuzz(TestOneInput, nil, args)
