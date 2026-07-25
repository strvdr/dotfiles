return {

    "xiyaowong/transparent.nvim",

    config = function()

        require("transparent").setup({
          --groups = { 'Normal' },
          --on_clear = function() end
        })

    end
}
