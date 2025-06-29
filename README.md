# nvim-dap-repl-highlights

Add syntax highlighting to the [nvim-dap](https://github.com/mfussenegger/nvim-dap) REPL buffer using treesitter.

| Before                                                                                                          | After                                                                                                          |
| --------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| ![before](https://user-images.githubusercontent.com/20954878/235993939-a3ad95eb-9dfa-41a4-b70e-3a4e890e2adf.png) | ![image](https://user-images.githubusercontent.com/20954878/235993604-642fe658-6cc9-40e0-846c-00df11d963e1.png)|

## Notable Changes

This is a fork.

* Requires nvim **0.11**+
* Requires main branch from treesitter
* Adapter filetype is entirely based on the adapter

## Requirements

* Neovim 0.11 or later
* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## Setup

Install the plugin and the requirements using your favourite method. Once installed, make sure you configured treesitter then add the following to your lua config

```lua
require("nvim-dap-repl-highlights").setup() -- see options below
```

After initially setting up the plugin the `dap_repl` parser needs to be installed, this can be done manually by running `:TSInstall dap_repl`.

Or automatically through Treesitter configuration:

> ⚠️ **NOTE:** You must call nvim-dap-repl-highlights.setup() before Treesitter, or the dap_repl parser won't be found.

**Using `nvim-treesitter.install` (nvim-treesitter main branch)**

```lua
require("nvim-dap-repl-highlights").setup()
require("nvim-treesitter").install({ "dap_repl" })
```

> ⚠️ If this ever stops working or the API changes, check the official Treesitter docs for the latest install method:
> 👉 <https://github.com/nvim-treesitter/nvim-treesitter>

### Mappings adapters to filetypes

You can specify options to extend the supported filetypes.

```lua
require("nvim-dap-repl-highlights").setup({
    -- maps an adapter to a filetype
    adapters = {
        debugpy = "python",
        -- ...
    },
})
```

 Consider contributing to the plugin if something is missing.
