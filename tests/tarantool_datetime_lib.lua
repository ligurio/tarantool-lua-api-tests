local MAX_DATE_YEAR = 5879611
local MIN_DATE_YEAR = -MAX_DATE_YEAR

local fmt_conv_spec = {
    '%a',
    '%A',
    '%b',
    '%B',
    '%h',
    '%c',
    '%C',
    '%d',
    '%e',
    '%D',
    '%H',
    '%I',
    '%j',
    '%m',
    '%M',
    '%n',
    '%p',
    '%r',
    '%R',
    '%S',
    '%t',
    '%T',
    '%U',
    '%w',
    '%W',
    '%x',
    '%X',
    '%y',
    '%Y',
}

local function keys(t)
    assert(next(t) ~= nil)
    local table_keys = {}
    for k, _ in pairs(t) do
        table.insert(table_keys, k)
    end
    return table_keys
end

local function oneof(tbl, fdp)
    assert(type(tbl) == 'table')
    assert(next(tbl) ~= nil)
    assert(fdp)

    local n = table.getn(tbl)
    local idx = fdp:consume_integer(1, n)

    return tbl[idx]
end

-- https://docs.microsoft.com/en-us/office/troubleshoot/excel/determine-a-leap-year
local function is_leap_year(year)
    -- bool leap = st.wYear % 4 == 0 && (st.wYear % 100 != 0 || st.wYear % 400 == 0);
    if year % 4 ~= 0 then
        return false
    elseif year % 100 ~= 0 then
        return true
    elseif year % 400 ~= 0 then
        return false
    else
        return true
    end
end

local function random_usec(fdp)
    return fdp:consume_integer(0, 10^3)
end

local function random_msec(fdp)
    return fdp:consume_integer(0, 10^6)
end

local function random_nsec(fdp)
    return fdp:consume_integer(0, 10^9)
end

local function random_sec(fdp)
    return fdp:consume_integer(0, 60)
end

local function random_min(fdp)
    return fdp:consume_integer(0, 59)
end

local function random_hour(fdp)
    return fdp:consume_integer(0, 23)
end

local function random_day(fdp)
    return fdp:consume_integer(1, 31)
end

local function random_month(fdp)
    return fdp:consume_integer(1, 12)
end

local function random_year(fdp, is_leap)
    local y = fdp:consume_integer(MIN_DATE_YEAR, MAX_DATE_YEAR)
    if is_leap and not is_leap_year(y) then
        return random_year(fdp, is_leap)
    end
    return y
end

local function random_tzoffset(fdp)
    -- TODO: '+02:00'
    return fdp:consume_integer(-720, 840)
end

local function random_tz(fdp)
    return oneof(datetime.TZ)
end

-- Maximum supported date - 5879611-07-11.
-- Minimum supported date - -5879610-06-22.
-- TODO: Only one of nsec, usec or msecs may be defined
--       simultaneously.
-- TODO: Day equal to -1 is a special.
local function random_dt_fields(fdp)
    return {
        sec       = random_sec(fdp),
        min       = random_min(fdp),
        hour      = random_hour(fdp),
        day       = random_day(fdp),
        month     = random_month(fdp),
        year      = random_year(fdp),
        tzoffset  = random_tzoffset(fdp),
        tz        = random_tz(fdp),
    }
end

local function random_dt_str(fdp)
    -- Field descriptors.
    local n = fdp:consume_integer(1, 5)
    local fmt = ''
    for _ = 1, n do
        local field_idx = fdp:consume_integer(1, #fmt_conv_spec)
        fmt = ("%s%s"):format(fmt, fmt_conv_spec[field_idx])
    end

    return fmt
end

return {
    random_dt_str = random_dt_str,
    random_dt_fields = random_dt_fields,

    random_usec = random_usec,
    random_msec = random_msec,
    random_nsec = random_nsec,
    random_sec = random_sec,
    random_min = random_min,
    random_hour = random_hour,
    random_day = random_day,
    random_month = random_month,
    random_year = random_year,
    random_tzoffset = random_tzoffset,
    random_tz = random_tz,

    keys = keys,
    oneof = oneof,
}
