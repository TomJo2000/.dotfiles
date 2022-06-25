-- Regular config
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function()
    use 'wbthomason/packer.nvim' -- packer plugin manager
    use 'neovim/nvim-lspconfig' -- nvim Language Server Protocol support
    use {'nvim-treesitter/nvim-treesitter' , run = ':TSUpdate'} --Treesitter improved syntax highlighting
    use 'hrsh7th/nvim-cmp' -- nvim completion engine
    use 'hrsh7th/cmp-nvim-lsp' -- LSP/completions interface
    use 'hrsh7th/cmp-buffer' -- completions buffer
    use 'hrsh7th/cmp-path' -- completions path
    use 'hrsh7th/cmp-cmdline' -- completions command line
    use {'nvim-telescope/telescope.nvim', -- Telescope file search
    	requires = { {'nvim-lua/plenary.nvim'} } } -- Plenary, dependency for Telescope
    use 'kyazdani42/nvim-tree.lua' -- a file explorer for Neovim written in Lua
    use 'kyazdani42/nvim-web-devicons' -- file icons
    use 'lukas-reineke/indent-blankline.nvim' -- better guide lines
    use 'norcalli/nvim-colorizer.lua' -- highlight color codes
end)
