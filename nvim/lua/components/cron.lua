local M = {}

M.cronConfig = function()
	require("cronex").setup({
		explainer = {
			cmd = "hcron",
			args = { "-24-hour", "-locale", "zh_CN" },
		},

		format = function(s)
			return require("cronex.format").all_after_colon(s)
		end,
	})

	cmd([[
augroup input_method
  autocmd!
  autocmd InsertEnter * :CronExplainedEnable
  autocmd InsertLeave * :CronExplainedEnable
augroup END
]])

	cmd("CronExplainedEnable")
end

return M
