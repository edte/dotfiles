local function vim_mode(key, env)
	-- Esc keycode = 65307
	if key.keycode == 65307 then
		local is_ascii = env.engine.context:get_option("ascii_mode")
		if not is_ascii then
			env.engine.context:set_option("ascii_mode", true)
		end
	end
	return 2
end

return vim_mode
