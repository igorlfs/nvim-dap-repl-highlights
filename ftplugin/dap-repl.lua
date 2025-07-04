local dap = require("dap")

local repl_hl = require("nvim-dap-repl-highlights")

local api = vim.api

local bufnr = api.nvim_get_current_buf()

local listener_name = "nvim-dap-repl-highlights.init_listner_buf_" .. bufnr

---@param session dap.Session?
local function setup_injections(session)
    if not bufnr then
        return
    end

    local lang = repl_hl.get_repl_lang_for_session(session)

    repl_hl.setup_injections(bufnr, lang)
end

-- setup injection on existing buffer
dap.listeners.after.event_initialized[listener_name] = function(session)
    if not api.nvim_buf_is_valid(bufnr) then
        -- removing listeners in case the buffer is no longer valid
        return true
    end

    setup_injections(session)
end

local session = dap.session()

setup_injections(session)
