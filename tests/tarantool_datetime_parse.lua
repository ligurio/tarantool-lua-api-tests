local datetime = require("datetime")
local luzer = require("luzer")

local function TestOneInput(buf)
    pcall(datetime.parse, buf)
end

local args = {
    print_pcs = 1,
    artifact_prefix = "datetime_parse_",
    max_len = 2048,
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
