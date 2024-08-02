-- "Three bytes of death"
-- https://github.com/tarantool/tarantool/issues/4773

local luzer = require("luzer")
local popen = require("popen")

local TARANTOOL_PATH = arg[-1]

local function TestOneInput(buf)
    local ph = popen.new({ TARANTOOL_PATH }, {
        shell = true,
        setsid = true,
        stdout = popen.opts.INHERIT,
        stderr = popen.opts.INHERIT,
        stdin = popen.opts.PIPE,
    })
    if not ph then
        return
    end
    assert(ph)
    ph:write(buf .. "\n")
    ph:shutdown({ stdin = true })
    ph:wait()
    ph:close()
end

local args = {
    max_len = 4096,
    print_pcs = 1,
    detect_leaks = 1,
    artifact_prefix = "stdio_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
