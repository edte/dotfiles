local ms = vim.lsp.protocol.Methods

local capabilities = {
	capabilities = {
		hoverProvider = true,
	},
	serverInfo = {
		name = 'url-hover',
		version = '0.0.1',
	},
}

local function trim_trailing_punctuation(url)
	return url:gsub('[%]%)>,;:!?.]+$', '')
end

local function cursor_col0()
	return vim.api.nvim_win_get_cursor(0)[2]
end

local function find_url_in_line()
	local line = vim.api.nvim_get_current_line()
	local col = cursor_col0()

	for s, e in line:gmatch("()https?://[%w%-%._~:/%?#%[%]@!$&'()*+,;=%%]+()") do
		if col >= (s - 1) and col <= (e - 2) then
			return trim_trailing_punctuation(line:sub(s, e - 1))
		end
	end

	for s, e, inner in line:gmatch("()%[[^%]]-%]%((https?://[^)%s]+)%)()") do
		if col >= (s - 1) and col <= (e - 2) then
			return trim_trailing_punctuation(inner)
		end
	end

	return nil
end

local function cursor_is_url()
	local urls = vim.ui._get_urls()
	if not vim.tbl_isempty(urls) then
		local url = trim_trailing_punctuation(urls[1])
		if vim.startswith(url, 'https://') or vim.startswith(url, 'http://') then
			return true, url
		end
	end

	local inline_url = find_url_in_line()
	if inline_url then
		return true, inline_url
	end

	return false, nil
end

local cache = {}

-- TODO: make async once the vim.spinner is available, and display a spinner while fetching the content
local function fetch_markdown(url)
	if cache[url] then
		return cache[url]
	end

	local out = vim.system({ 'curl', '-fsSL', '--max-time', '8', 'https://markdown.new/' .. url }, { text = true }):wait()
	if out.code == 0 and out.stdout and out.stdout ~= '' then
		cache[url] = out.stdout
		return out.stdout
	end

	return string.format('Failed to fetch markdown content: %s', url)
end

return {
	cmd = function()
		return {
			request = function(method, _, handler, _)
				if method == ms.textDocument_hover then
					local is_url, url = cursor_is_url()
					if is_url then
						handler(nil, {
							contents = {
								kind = 'markdown',
								value = fetch_markdown(url),
							},
						})
						return
					end

					handler(nil, nil)
				elseif method == ms.initialize then
					handler(nil, capabilities)
				else
					handler(nil, nil)
				end
			end,
			notify = function() end,
			is_closing = function()
				return false
			end,
			terminate = function() end,
		}
	end,
	name = 'url-hover',
}
