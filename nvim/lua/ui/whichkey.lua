--------------------------------------------------------------which key ------------------------------------------------------------------------

local wk = require("which-key")

wk.add({
    mode = { "v" },
    { "<leader>/",  "<Plug>(comment_toggle_linewise_visual)", desc = "comment", },
    { "<leader>l",  group = "LSP",                            desc = "lsp", },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", },
    { "<leader>t",  ":'<,'>Translate ZH<cr>",                 desc = "Translate", },
    { "<leader>d",  ":lua compare_to_clipboard()<cr>",        desc = "Diff", },
})

wk.add({
    mode = { "n" },

    { "<leader>/",  "<Plug>(comment_toggle_linewise_current)",                  desc = "comment", },
    { "<leader>C",  "<cmd>%bd|e#|bd#<CR>",                                      desc = "Close Other Buffer", },
    { "<leader>c",  "<cmd>bd<CR>",                                              desc = "close Buffer", },
    { "<leader>e",  "<cmd>lua ToggleMiniFiles()<CR>",                           desc = "Explorer", },
    { "<leader>f",  "<cmd>lua project_files()<CR>",                             desc = "files", },
    { "<leader>g",  group = "git",                                              desc = "git" },
    { "<leader>gb", "<cmd>FzfLua git_branches<cr>",                             desc = "branch", },
    { "<leader>gc", "<cmd>FzfLua git_commits<cr>",                              desc = "commit", },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                          desc = "diff", },
    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",             desc = "blame", },
    { "<leader>gs", "<cmd>FzfLua git_status<cr>",                               desc = "status", },
    { "<leader>l",  group = "lsp",                                              desc = "lsp" },
    { "<leader>lI", "<cmd>Mason<cr>",                                           desc = "Mason Info", },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",                   desc = "Code Action", },
    { "<leader>ld", "<cmd>FzfLua diagnostics_document<cr>",                     desc = "Buffer Diagnostics", },
    { "<leader>le", "<cmd>FzfLua quickfix<cr>",                                 desc = "FzfLua Quickfix", },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>",                        desc = "Format", },
    { "<leader>li", "<cmd>LspInfo<cr>",                                         desc = "Info", },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>",                 desc = "Quickfix", },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",                        desc = "Rename", },
    { "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>",                     desc = "Document Symbols", },
    { "<leader>lw", "<cmd>FzfLua diagnostics_workspace<cr>",                    desc = "Diagnostics", },
    { "<leader>p",  "<cmd>Lazy<cr>",                                            desc = "plugins", },
    { "<leader>q",  "<cmd>confirm q<CR>",                                       desc = "quit", },
    { "<leader>r",  "<cmd>FzfLua oldfiles<CR>",                                 desc = "recents", },

    { "<leader>s",  group = "search",                                           desc = "search" },
    { "<leader>sh", "<cmd>FzfLua highlights<cr>",                               desc = "highlight", },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>",                                 desc = "autocmds", },
    { "<leader>sf", "<cmd>FzfLua files<cr>",                                    desc = "file", },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>",                                  desc = "keymaps", },
    { "<leader>sr", "<cmd>FzfLua resume<cr>",                                   desc = "resume", },
    { "<leader>st", "<cmd>FzfLua live_grep<cr>",                                desc = "text", },
    { "<leader>sp", '<cmd>lua require("fzf-lua-lazy").search()<cr>',            desc = "plugins", },
    { "<leader>sc", "<cmd>edit" .. NEOVIM_CONFIG_PATH .. "/init.lua" .. "<CR>", desc = "config", },
    { "<leader>su", "<cmd>UndotreeToggle<CR>",                                  desc = "undo", },

    { "<leader>t",  "<cmd>FzfLua live_grep_native<CR>",                         desc = "text", },
    { "gh",         "0",                                                        desc = "home begin", },
    { "gl",         "$",                                                        desc = "home end", },
    { "gs",         "_",                                                        desc = "_", },
    { "ge",         "G",                                                        desc = "G" },


})
