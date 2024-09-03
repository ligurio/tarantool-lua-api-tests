local datetime = require("datetime")
local datetime_lib = require("tarantool_datetime_lib")
local luzer = require("luzer")

local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)
    local dt_fields = datetime_lib.random_dt_str(fdp)
    local dt = datetime.new(dt_fields)

    -- PROPERTY: dt_fields == datetime.new(dt_fields):totable()
    table.equals(dt_fields, dt:totable())

    -- PROPERTY: dt == datetime.new({ timestamp = dt.timestamp })
    -- BROKEN: -4613096-08-31T19:19:36.119810579+0518 == -4613096-08-31T14:01:36.125Z
    assert(dt == datetime.new({ timestamp = dt.timestamp }))

    -- PROPERTY: datetime.new(dt) == datetime.new():set(dt)
    assert(dt == datetime.new():set(dt_fields), "new(dt) == new():set(dt)")

    -- PROPERTY: Last day in a February is 28 in non-leap year,
    --           and 29 in a leap year.
    local is_leap = datetime_lib.oneof({true, false})
    dt = datetime.new({
        year = datetime_lib.random_year(fdp, is_leap),
        month = 02,
        day = -1,
    })
    assert(dt.day == is_leap and 29 or 28, "last day in February")
end

local args = {
    print_pcs = 1,
    artifact_prefix = "datetime_ctr_",
    max_len = 2048,
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
