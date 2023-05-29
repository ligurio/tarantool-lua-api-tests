-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/yaml/
-- https://github.com/tarantool/tarantool/issues/4773 \x36\x00\x80

local yaml = require("yaml")
local luzer = require("luzer")

local function TestOneInput(buf)
    local ok, res = pcall(yaml.decode, buf)
    if ok == false then
        return
    end
    yaml.encode(res)
end

local args = {
    max_len = 128,
    print_pcs = 1,
    artifact_prefix = "tarantool_yaml_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
