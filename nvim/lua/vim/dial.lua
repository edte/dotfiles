local M = {}

M.dialConfig = function()
	local augend = require("dial.augend")
	require("dial.config").augends:register_group({
		default = {
			augend.hexcolor.new({
				case = "lower",
			}),

			augend.constant.new({
				elements = { "and", "or" },
				word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
				cyclic = true, -- "or" is incremented into "and".
			}),
			augend.constant.new({
				elements = { "&&", "||" },
				word = false,
				cyclic = true,
			}),

			augend.integer.alias.decimal,
			augend.integer.alias.decimal_int,
			augend.integer.alias.hex,
			augend.date.alias["%Y/%m/%d"],
			augend.date.alias["%H:%M:%S"],
			augend.date.alias["%H:%M"],
			augend.date.alias["%Y年%-m月%-d日"],
			augend.date.alias["%Y年%-m月%-d日(%ja)"],
			augend.date.alias["%-d.%-m."],
			augend.date.alias["%d.%m."],
			augend.date.alias["%d.%m.%y"],
			augend.date.alias["%d.%m.%Y"],
			augend.date.alias["%Y-%m-%d"],
			augend.date.alias["%-m/%-d"],
			augend.date.alias["%d/%m/%y"],
			augend.date.alias["%m/%d/%y"],
			augend.date.alias["%d/%m/%Y"],
			augend.date.alias["%m/%d/%Y"],
			augend.date.alias["%Y/%m/%d"],
			augend.integer.alias.octal,
			augend.integer.alias.binary,
			augend.constant.alias.alpha,
			augend.constant.alias.Alpha,
			augend.semver.alias.semver,
			augend.constant.alias.bool,
		},
		visual = {
			augend.hexcolor.new({
				case = "lower",
			}),

			augend.constant.new({
				elements = { "and", "or" },
				word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
				cyclic = true, -- "or" is incremented into "and".
			}),
			augend.constant.new({
				elements = { "&&", "||" },
				word = false,
				cyclic = true,
			}),

			augend.integer.alias.decimal,
			augend.integer.alias.decimal_int,
			augend.integer.alias.hex,
			augend.date.alias["%Y/%m/%d"],
			augend.date.alias["%H:%M:%S"],
			augend.date.alias["%H:%M"],
			augend.date.alias["%Y年%-m月%-d日"],
			augend.date.alias["%Y年%-m月%-d日(%ja)"],
			augend.date.alias["%-d.%-m."],
			augend.date.alias["%d.%m."],
			augend.date.alias["%d.%m.%y"],
			augend.date.alias["%d.%m.%Y"],
			augend.date.alias["%Y-%m-%d"],
			augend.date.alias["%-m/%-d"],
			augend.date.alias["%d/%m/%y"],
			augend.date.alias["%m/%d/%y"],
			augend.date.alias["%d/%m/%Y"],
			augend.date.alias["%m/%d/%Y"],
			augend.date.alias["%Y/%m/%d"],
			augend.integer.alias.octal,
			augend.integer.alias.binary,
			augend.constant.alias.alpha,
			augend.constant.alias.Alpha,
			augend.semver.alias.semver,
			augend.constant.alias.bool,
		},
	})

	keymap("", "<C-a>", "<Plug>(dial-increment)")
	keymap("", "<C-x>", "<Plug>(dial-decrement)")
	keymap("n", "<C-a>", "<Plug>(dial-increment)")
	keymap("n", "<C-x>", "<Plug>(dial-decrement)")
	keymap("v", "<C-a>", "<Plug>(dial-increment)")
	keymap("v", "<C-x>", "<Plug>(dial-decrement)")
end

return M
