-- https://github.com/tarantool/tarantool/issues/3866
-- https://github.com/tarantool/tarantool/issues/3861

local luzer = require("luzer")

local function TestOneInput(buf)
    os.execute("rm -f *.snap")
    require("fiber").sleep(0.1)
    box.cfg({})
    box.execute(buf)
end

local args = {
    max_len = 4096,
    print_pcs = 1,
    artifact_prefix = "box_execute_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
