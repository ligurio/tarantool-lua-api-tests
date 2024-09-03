local datetime = require("datetime")
local datetime_lib = require("tarantool_datetime_lib")
local luzer = require("luzer")

local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)

    -- PROPERTY:
    local str = fdp:consume_string(100)
    local ok, dt = pcall(datetime.parse, str)
    if ok then
        datetime.parse(dt:format())
    end

    -- PROPERTY:
    -- datetime.parse(<buf>) == datetime.parse(<buf>, { format = <fmt> })
    local str, fmt = datetime_lib.random_dt_str(fdp)
    local ok, res1 = pcall(datetime.parse, str)
    if not ok then return end
    local ok, res2 = pcall(datetime.parse, str, { format = fmt })
    assert(ok == true)
    assert(res1 == res2)

    -- PROPERTY: datetime.parse(dt:format(random_format), {format = random_format}) == dt
    -- dt1 = datetime.new(time_units1)
    -- local dt1_str = dt1:format(datetime_fmt)
    -- local dt_parsed = datetime.parse(dt1_str, { format = datetime_fmt })
    -- assert(dt_parsed == dt1, tostring(dt_parsed) .. ' == ' .. dt1_str .. '(' .. datetime_fmt .. ')')
    -- BROKEN: Wrong assumption.
end

local args = {
    print_pcs = 1,
    artifact_prefix = "datetime_parse_",
    max_len = 2048,
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
