local M = {}

local globals = require("nvim-dap-repl-highlights.globals")
local utils = require("nvim-dap-repl-highlights.utils")
local ts_override = require("nvim-dap-repl-highlights.treesitter_override")
local buf_lang = {}

---@class replhl.Config
---@field adapters table<string,string>

---@type replhl.Config
local opts = {
    adapters = {
        ["pwa-node"] = "javascript",
        ["pwa-chrome"] = "javascript",
        debugpy = "python",
    },
}

---@param session dap.Session?
function M.get_repl_lang_for_session(session)
    if not session then
        return nil
    end
    return opts.adapters[session.config.type]
end

---@param bufnr number
---@param lang? string
function M.setup_injections(bufnr, lang)
    if lang and not utils.check_treesitter_parser_exists(globals.PARSER_NAME) then
        utils.notify_warn(globals.PARSER_NAME .. " parser not found, make sure you installed it using treesitter")
        return
    end
    if lang and not utils.check_treesitter_parser_exists(lang) then
        utils.notify_warn(lang .. " parser not found, make sure you installed it using treesitter")
        return
    end

    if buf_lang[bufnr] == lang then
        return
    end

    ---@type table<string,string>?
    local injections = {}
    if lang then
        injections[globals.PARSER_NAME] = '((user_input_statement) @injection.content (#set! injection.language "'
            .. lang
            .. '") (#set! injection.combined) (#set! injection.include-children))'
    else
        injections = nil
    end

    buf_lang[bufnr] = lang

    local tsparser = ts_override.get_parser(bufnr, globals.PARSER_NAME, { injections = injections })

    if tsparser then
        vim.treesitter.highlighter.new(tsparser)
    end
end

---@param language string
---@param bufnr number
function M.setup_highlights(language, bufnr)
    bufnr = bufnr or 0
    if language then
        M.setup_injections(bufnr, language)
    else
        vim.ui.input({ prompt = "Enter language parser name: " }, function(input)
            if input then
                M.setup_injections(bufnr, input)
            end
        end)
    end
end

---@param config replhl.Config
function M.setup(config)
    local parser_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h:h:h")

    opts = vim.tbl_deep_extend("force", opts, config or {})

    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("nvim_dap_repl_highlights", {}),
        pattern = "TSUpdate",
        callback = function()
            require("nvim-treesitter.parsers")[globals.PARSER_NAME] = {
                install_info = {
                    path = parser_path,
                    generate = false,
                    generate_from_json = false,
                    queries = "queries/dap_repl",
                },
            }
            vim.treesitter.language.register("dap_repl", { "dap_repl" })
        end,
    })
end

return M
