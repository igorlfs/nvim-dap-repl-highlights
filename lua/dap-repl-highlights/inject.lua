local M = {}

local utils = require("dap-repl-highlights.utils")
local buf_lang = {}
local ll = vim.log.levels

---@class replhl.Config
---@field adapters table<string,string>

---@type replhl.Config
M.opts = {
    adapters = {
        ["pwa-node"] = "javascript",
        ["pwa-chrome"] = "javascript",
        debugpy = "python",
        nlua = "lua",
        emmylua = "lua",
    },
}

---@param bufnr integer
---@param session dap.Session?
function M.inject_hl_by_session(bufnr, session)
    if not session or not bufnr then
        return
    end
    local lang = M.opts.adapters[session.config.type]

    if lang == nil then
        return
    end

    if lang and not utils.check_treesitter_parser_exists(utils.PARSER_NAME) then
        vim.notify(utils.PARSER_NAME .. " parser not found, make sure you installed it using treesitter", ll.WARN)
        return
    end
    if lang and not utils.check_treesitter_parser_exists(lang) then
        vim.notify(lang .. " parser not found, make sure you installed it using treesitter", ll.WARN)
        return
    end

    if buf_lang[bufnr] == lang then
        return
    else
        buf_lang[bufnr] = lang
    end

    local injections = string.format(
        [[(
            (user_input_statement) @injection.content
            (#set! injection.language "%s")
            (#set! injection.combined)
            (#set! injection.include-children)
        )]],
        lang
    )

    -- TODO the injection is not updated if the language changes
    vim.treesitter.query.set(utils.PARSER_NAME, "injections", injections)

    vim.treesitter.start(bufnr, utils.PARSER_NAME)
end

return M
