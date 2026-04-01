local dap = require("dap")

local api = vim.api

dap.listeners.after.event_initialized["nvim-dap-repl-highlights"] = function(session)
    vim.iter(api.nvim_list_bufs())
        :filter(function(buf)
            return vim.bo[buf].filetype == "dap-repl" and api.nvim_buf_is_valid(buf)
        end)
        :each(function(buf)
            require("dap-repl-highlights").inject_hl_by_session(buf, session)
        end)
end
