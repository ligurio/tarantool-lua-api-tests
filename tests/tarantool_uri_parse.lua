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

local args = {
    max_len = 1024,
    artifact_prefix = "uri_parse_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
