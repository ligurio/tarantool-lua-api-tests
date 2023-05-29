-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/uri/

local uri = require("uri")
local luzer = require("luzer")

local function TestOneInput(buf)
    local url = uri.unescape(buf)
    if url ~= nil then
        assert(uri.escape(url) == buf)
    end
end

local args = {
    max_len = 1024,
    artifact_prefix = "uri_escape_",
    max_total_time = 60,
    print_final_stats = 1,
}
luzer.Fuzz(TestOneInput, nil, args)
