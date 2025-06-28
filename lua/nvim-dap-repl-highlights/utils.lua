local M = {}

---@param language string
function M.check_treesitter_parser_exists(language)
    local installed_parsers = require("nvim-treesitter.config").get_installed("parsers")

    return vim.iter(installed_parsers):find(function(parser)
        return parser == language
    end)
end

---@param message string
function M.notify_warn(message)
    vim.notify(message, vim.log.levels.WARN)
end

return M
