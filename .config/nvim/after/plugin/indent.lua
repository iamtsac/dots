vim.opt.list = true
vim.opt.listchars:append "space: , trail: , tab:   "

require("indent_blankline").setup {
    char = '│',
    show_end_of_line = false,
    show_current_context_start = false,
    show_current_context_start_on_current_line = false,
    -- space_char_blankline = '┃',
    indent_level = 10,
    show_first_indent_level=true,
    show_current_context_start_on_current_line = false,
    use_treesitter = false,
    -- char_list = {'┃', '┃', '┃', '┃'},
    -- char_list_blankline = {'┃', '┃', '┃', '┃'}
    -- char_highlight_list = {'Error', 'Function'}
}
