require("neogit").setup({
    graph_style = "unicode",
    kind = "replace",
    commit_editor = {
        kind = "tab",
        staged_diff_split_kind = "vsplit",
    },
    commit_select_view = {
        kind = "split",
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
        kind = "tab",
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
        kind = "tab",
    },
    refs_view = {
        kind = "tab",
    },
    mappings = {
        status = {
            -- Disable the default quit behavior
            ["q"] = false,
        },
    },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NeogitStatus",
  callback = function(args)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.keymap.set("n", "q", function()
          Snacks.bufdelete()
        end, { buffer = args.buf, silent = true, nowait = true })
      end
    end)
  end,
})
