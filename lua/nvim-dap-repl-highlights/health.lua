local M = {}

local rl = require("nvim-dap-repl-highlights")
local utils = require("nvim-dap-repl-highlights.utils")
local health = vim.health

function M.check()
    if vim.fn.has("nvim-0.11.0") == 0 then
        health.error("nvim-dap-repl-highlights requires neovim version >= 0.11.0")
        return
    end

    if utils.check_treesitter_parser_exists(rl.PARSER_NAME) then
        health.ok("")
    else
        health.warn(rl.PARSER_NAME .. " parser not installed", "Run TSInstall " .. rl.PARSER_NAME)
    end
end

return M
