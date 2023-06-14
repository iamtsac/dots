local previewers = require("telescope.previewers")

require('telescope').setup {
	defaults = {
		-- Default configuration for telescope goes here:
		-- config_key = value,
		theme = "ivy",
		mappings = {
			i = {
				-- map actions.which_key to <C-h> (default: <C-/>)
				-- actions.which_key shows the mappings for your picker,
				-- e.g. git_{create, delete, ...}_branch for the git_branches picker
				["<C-h>"] = "which_key"
			}
		}
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		find_files = {
			theme = "ivy",
			hidden = true,
			no_ignore = false,
			no_ignore_parents = false,
		},
		buffers = {
			theme = "ivy",
			ignore_current_buffer = true,
			sort_lastused = true,
			previewer = false
		},
		git_commits = {
			theme = "ivy",
		},
		git_bcommits = {
			theme = "ivy",
		},
		git_status = {
			theme = "ivy",
		},
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg" },
			-- find command (defaults to `fd`)
			find_cmd = "rg"
		}
	},
}
require("telescope").load_extension "file_browser"
require('telescope').load_extension('media_files')
