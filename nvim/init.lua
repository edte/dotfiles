local requires = {
    -- "base.mini",

    "alias",
    "options",
    "autocmds",
    "commands",
    "keymaps",
    "lazys",
}

for _, r in ipairs(requires) do
    require(r)
end
