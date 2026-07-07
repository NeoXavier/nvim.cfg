return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release, remove to use latest commit
    lazy = false,
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
        legacy_commands = false, -- this will be removed in 4.0.0
        workspaces = {
            {
                name = "work",
                path = "~/Vaults/work-notes",
            },
            {
                name = "personal",
                path = "~/Vaults/personal-notes",
            },
        },
        daily_notes = {
            enabled = true,
            folder = "Daily Notes",
            date_format = "DDMMYYYY [Daily Note]",
            alias_format = nil,
            default_tags = { "daily-notes" },
            workdays_only = true,
        },
        templates = {
            folder = "Templates",
            date_format = "DDMMYYYY",
            time_format = "%H:%M",
        },
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            if title ~= nil then
                return title
            else
                return tostring(os.time()) .. '-' .. 'untitled'
            end
        end,
    },
    keys = {
        { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "[O]bsidian [T]oday" },
        { "<leader>os", "<cmd>Obsidian search<cr>", desc = "[O]bsidian [S]earch" },
        { "<leader>ov", "<cmd>Obsidian quick_switch<cr>", desc = "[O]bsidian [V]ault" },
        { "<leader>on", "<cmd>Obsidian unique_note<cr>", desc = "[O]bsidian [N]ote" },
        { "<leader>ob", [[:Obsidian ]], desc = "[Ob]sidian" },
    }
}
