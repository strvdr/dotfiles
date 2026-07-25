return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd", "cssls", "dockerls", "zls" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        config = function()
            -- ZLS: explicitly point to your zig executable so ZLS can
            -- resolve the standard library path
            vim.lsp.config("zls", {
                settings = {
                    zls = {
                        zig_exe_path = "/usr/bin/zig",
                    },
                },
            })

            -- Enable all language servers
            vim.lsp.enable({ "lua_ls", "clangd", "cssls", "dockerls", "zls" })

            -- Set up keymaps when any LSP attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            })
        end,
    },
}
