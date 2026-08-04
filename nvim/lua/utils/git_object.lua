local M = {}

local function cat_file(git_dir, flag, object_id)
	local result = vim
		.system({
			'git',
			'--git-dir=' .. git_dir,
			'cat-file',
			flag,
			object_id,
		})
		:wait()

	if result.code ~= 0 then
		local message = vim.trim(result.stderr or 'git cat-file failed')
		return nil, string.format('git cat-file %s %s failed: %s', flag, object_id, message)
	end

	return result.stdout or ''
end

function M.read(path)
	path = vim.fs.normalize(path)
	local git_dir, prefix, suffix = path:match('^(.-)/objects/([0-9a-fA-F][0-9a-fA-F])/([0-9a-fA-F]+)$')
	if not git_dir then
		return
	end

	local object_id = prefix .. suffix
	if #object_id ~= 40 and #object_id ~= 64 then
		return
	end

	local type_output, type_error = cat_file(git_dir, '-t', object_id)
	if not type_output then
		return nil, type_error
	end

	local content, content_error = cat_file(git_dir, '-p', object_id)
	if not content then
		return nil, content_error
	end

	local object_type = vim.trim(type_output)
	local content_lines = vim.split(content, '\n', { plain = true })
	local ends_with_newline = content:sub(-1) == '\n'
	if ends_with_newline then
		table.remove(content_lines)
	end

	local lines = {
		'object: ' .. object_id,
		'git cat-file -t: ' .. object_type,
		'git cat-file -p:',
		'',
	}
	vim.list_extend(lines, content_lines)

	return {
		lines = lines,
		ends_with_newline = ends_with_newline,
	}
end

return M
