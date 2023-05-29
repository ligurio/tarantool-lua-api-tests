-- "One byte of death"
-- https://github.com/tarantool/tarantool/issues/6781
-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/net_box/

local luzer = require("luzer")
local net_box = require("net.box")

local function TestOneInput(buf)
    os.execute("rm -f *.snap")
    local socket_path = os.tmpname()
    box.cfg{
        listen = socket_path,
    }
    local conn = net_box.connect(socket_path)
	pcall(conn.call, conn, buf)
end

local args = {
    max_len = 4096,
    print_pcs = 1,
    artifact_prefix = "net_box_call_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
