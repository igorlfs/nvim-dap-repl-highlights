require("dap-repl-highlights.listeners")

local M = {}

---@param bufnr integer
---@param session dap.Session?
M.inject_hl_by_session = function(bufnr, session)
    require("dap-repl-highlights.inject").inject_hl_by_session(bufnr, session)
end

return M
