return {
    "axieax/urlview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }, -- Optional for Telescope integration
    config = function()
        require("urlview").setup({})
    end
}
