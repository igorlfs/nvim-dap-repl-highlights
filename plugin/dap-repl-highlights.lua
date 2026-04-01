local api = vim.api

api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        local parser_path = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h:h")

        require("nvim-treesitter.parsers")[require("dap-repl-highlights.utils").PARSER_NAME] = {
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

api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function(args)
        local session = require("dap").session()

        require("dap-repl-highlights").inject_hl_by_session(args.buf, session)
    end,
})
