-- Logger for language client plugin.

local M = {}

local log_levels = vim.log.levels

--- Log level dictionary with reverse lookup as well.
---
--- Can be used to lookup the number from the name or the name from the number.
--- Levels by name: "TRACE", "DEBUG", "INFO", "WARN", "ERROR", "OFF"
--- Level numbers begin with "TRACE" at 0
--- @type table<string,integer> | table<integer, string>
--- @nodoc
M.levels = vim.deepcopy(log_levels)

-- Default log level is warn.
local current_log_level = log_levels.WARN

local log_date_format = '%F %H:%M:%S'

local function format_func(arg)
    return vim.inspect(arg, { newline = ' ', indent = '' })
end

local function notify(msg, level)
    if vim.in_fast_event() then
        vim.schedule(function()
            vim.notify(msg, level)
        end)
    else
        vim.notify(msg, level)
    end
end

local logfilename = vim.fs.joinpath(vim.fn.stdpath('log') --[[@as string]], 'message.log')

-- TODO: Ideally the directory should be created in open_logfile(), right
-- before opening the log file, but open_logfile() can be called from libuv
-- callbacks, where using fn.mkdir() is not allowed.
vim.fn.mkdir(vim.fn.stdpath('log') --[[@as string]], 'p')


--- @type file*?, string?
local logfile, openerr

--- Opens log file. Returns true if file is open, false on error
local function open_logfile()
    -- Try to open file only once
    if logfile then
        return true
    end
    if openerr then
        return false
    end

    logfile, openerr = io.open(logfilename, 'a+')
    if not logfile then
        local err_msg = string.format('Failed to open Message log file: %s', openerr)
        notify(err_msg, log_levels.ERROR)
        return false
    end

    local log_info = vim.uv.fs_stat(logfilename)
    if log_info and log_info.size > 1e9 then
        local warn_msg = string.format(
            'Message log is large (%d MB): %s',
            log_info.size / (1000 * 1000),
            logfilename
        )
        notify(warn_msg)
    end

    -- Start message for logging
    -- logfile:write(string.format('[START][%s] LSP logging initiated\n', os.date(log_date_format)))
    return true
end

for level, levelnr in pairs(log_levels) do
    -- Also export the log level on the root object.
    ---@diagnostic disable-next-line: no-unknown
    M[level] = levelnr

    -- Add a reverse lookup.
    M.levels[levelnr] = level
end

--- @param level string
--- @param levelnr integer
--- @return fun(...:any): boolean?
local function create_logger(level, levelnr)
    return function(...)
        if not M.should_log(levelnr) then
            return false
        end
        local argc = select('#', ...)
        if argc == 0 then
            return true
        end
        if not open_logfile() then
            return false
        end
        local info = debug.getinfo(2, 'Sl')
        local header = string.format(
            '[%s][%s] [%s:%s]',
            os.date(log_date_format),
            level,
            info.short_src,
            info.currentline
        )
        local parts = { header }
        for i = 1, argc do
            local arg = select(i, ...)
            table.insert(parts, arg == nil and 'nil' or format_func(arg))
        end
        assert(logfile)
        logfile:write(table.concat(parts, '\t'), '\n')
        logfile:flush()
    end
end

-- If called without arguments, it will check whether the log level is
-- greater than or equal to this one. When called with arguments, it will
-- log at that level (if applicable, it is checked either way).

--- @nodoc
M.debug = create_logger('DEBUG', log_levels.DEBUG)

--- @nodoc
M.error = create_logger('ERROR', log_levels.ERROR)

--- @nodoc
M.info = create_logger('INFO', log_levels.INFO)

--- @nodoc
M.trace = create_logger('TRACE', log_levels.TRACE)

--- @nodoc
M.warn = create_logger('WARN', log_levels.WARN)

--- Sets the current log level.
---@param level (string|integer) One of `vim.lsp.log.levels`
function M.set_level(level)
    if type(level) == 'string' then
        current_log_level =
            assert(M.levels[level:upper()], string.format('Invalid log level: %q', level))
    else
        assert(type(level) == 'number', 'level must be a number or string')
        assert(M.levels[level], string.format('Invalid log level: %d', level))
        current_log_level = level
    end
end

--- Gets the current log level.
---@return integer current log level
function M.get_level()
    return current_log_level
end

--- Sets formatting function used to format logs
---@param handle function function to apply to logging arguments, pass vim.inspect for multi-line formatting
function M.set_format_func(handle)
    assert(handle == vim.inspect or type(handle) == 'function', 'handle must be a function')
    format_func = handle
end

--- Checks whether the level is sufficient for logging.
---@param level integer log level
---@return boolean : true if would log, false if not
function M.should_log(level)
    return level >= current_log_level
end

vim.api.nvim_create_user_command('Message', function()
    vim.cmd(string.format('e %s', logfilename))
end, { nargs = "*" })

vim.api.nvim_create_user_command('M', function()
    vim.cmd(string.format('e %s', logfilename))
end, { nargs = "*" })

return M
