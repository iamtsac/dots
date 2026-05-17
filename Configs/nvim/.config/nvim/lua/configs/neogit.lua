require("neogit").setup({
    graph_style = "unicode",
    commit_editor = {
        kind = "vsplit",
        staged_diff_split_kind = "split",

    },
    commit_select_view = {
        kind = "floating",
    },
    commit_view = {
        kind = "vsplit",
        verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
    },
    log_view = {
        kind = "vsplit",
    },
    rebase_editor = {
        kind = "auto",
    },
    reflog_view = {
        kind = "floating",
    },
    merge_editor = {
        kind = "auto",
    },
    preview_buffer = {
        kind = "floating_console",
    },
    popup = {
        kind = "split",
        show_title = false,
    },
    stash = {
        kind = "floating",
    },
    refs_view = {
        kind = "floating",
    },
})
