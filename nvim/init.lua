local requires = {
    "alias", -- 函数别名
    "lazys", -- 插件
}

for _, r in ipairs(requires) do
    require(r)
end
