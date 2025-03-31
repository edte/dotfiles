local requires = {
    "alias", -- 这个必须调，各个地方用的很多

    -- 最小配置，用于测试
    -- "mini",

    -- 常用配置
    "lazys",
}

for _, r in ipairs(requires) do
    require(r)
end
