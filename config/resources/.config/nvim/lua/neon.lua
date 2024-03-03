-- ########################## UTILS
local function hsv(h, s, v)
    s = s / 100
    v = v / 100
    h = h / 60

    local i = math.floor(h) % 6
    local f = h - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    local r, g, b

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    r = math.floor(r * 255 + 0.5)
    g = math.floor(g * 255 + 0.5)
    b = math.floor(b * 255 + 0.5)
    return string.format("#%02x%02x%02x", r, g, b)
end

local function set(key, mod, fg, bg)
    vim.cmd(
        "highlight "..key
	   .." gui="..mod[1]
       .." guifg="..fg[1]
       .." guibg="..bg[1]
	   .." cterm="..mod[2]
	   .." ctermfg="..fg[2]
	   .." ctermbg="..bg[2]
    )
end

-- ########################## COLORS
local c = {
    black = { hsv(0, 0, 0), 0 },
    gray_d = { hsv(0, 0, 25), 8 },
    gray = { hsv(0, 0, 50), 7 },
    gray_l = { hsv(0, 0, 75), 7 },
    white = { hsv(0, 0, 100), 15 },
    red = { hsv(0, 100, 100), 12 },
    orange = { hsv(30, 100, 100), 4 },
    orange_l = { hsv(30, 75, 100), 4 },
    yellow = { hsv(60, 100, 100), 14 },
    chartreuse_d = { hsv(90, 100, 75), 6 },
    chartreuse = { hsv(90, 100, 100), 6 },
    chartreuse_l = { hsv(90, 75, 100), 6 },
    green = { hsv(120, 100, 100), 10 },
    turquoise = { hsv(150, 100, 100), 2 },
    turquoise_l = { hsv(150, 75, 100), 2 },
    cyan = { hsv(180, 100, 100), 11 },
    royal_d = { hsv(210, 100, 75), 3 },
    royal = { hsv(210, 100, 100), 3 },
    royal_l = { hsv(210, 75, 100), 3 },
    blue = { hsv(240, 100, 100), 9 },
    purple = { hsv(270, 100, 100), 1 },
    purple_l = { hsv(270, 75, 100), 1 },
    pink = { hsv(300, 100, 100), 13 },
    pink_l = { hsv(300, 75, 100), 13 },
    salmon_d = { hsv(330, 100, 75), 5 },
    salmon = { hsv(330, 100, 100), 5 },
    salmon_l = { hsv(330, 75, 100), 5 },
    none = { "none", "none" }
}

-- ########################## MODIFIERS
local m = {
    bold = { "bold", "bold" },
    italic = { "italic", "italic" },
    underline = { "underline", "underline" },
    undercurl = { "undercurl", "undercurl" },
    reverse = { "reverse", "reverse" },
    standout = { "standout", "standout" },
    strikethrough = { "strikethrough", "strikethrough" },
    none = { "none", "none" }
}

-- ########################## SETUP
local function setup()
    -- ********************** GENERAL
    set("Normal", m.none, c.white, c.none) 
    set("LineNr", m.italic, c.gray, c.none)

    set("CursorLine", m.none, c.none, c.gray_d)
    set("CursorColumn", m.none, c.none, c.gray_d)
    set("SignColumn", m.none, c.gray, c.none)

    -- ********************** CODE SYNTAX
    set("Constant", m.none, c.white, c.none)
    set("Comment", m.italic, c.gray, c.none)
    set("Special", m.none, c.orange_l, c.none)

    set("Identifier", m.none, c.royal, c.none)
    set("Statement", m.none, c.royal, c.none)
    set("PreProc", m.bold, c.royal_l, c.none)
    
    -- ********************** SH
    set("shLoop", m.bold, c.salmon_l, c.none)
    set("shConditional", m.bold, c.salmon_l, c.none)
    set("shOperator", m.bold, c.salmon_l, c.none)
    set("shRange", m.none, c.salmon_d, c.none)

    set("shDo", m.bold, c.chartreuse_l, c.none)
    set("shIf", m.bold, c.chartreuse_l, c.none)
    set("shCommand", m.bold, c.chartreuse_l, c.none)
    set("shCommandSub", m.bold, c.chartreuse_l, c.none)
    set("shOption", m.none, c.chartreuse_d, c.none)
    set("bashStatement", m.none, c.chartreuse_l, c.none)

    set("shQuote", m.bold, c.yellow, c.none)
end

return { setup = setup }
