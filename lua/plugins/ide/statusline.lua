local function get_attached_clients()
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
        return "LSP Inactive"
    end

    local buf_ft = vim.bo.filetype
    local buf_client_names = {}

    -- add client
    for _, client in pairs(buf_clients) do
        if client.name ~= "copilot" and client.name ~= "null-ls" then
            table.insert(buf_client_names, client.name)
        end
    end

    -- Generally, you should use either null-ls or nvim-lint + formatter.nvim, not both.

    -- Add sources (from null-ls)
    -- null-ls registers each source as a separate attached client, so we need to filter for unique names down below.
    local null_ls_s, null_ls = pcall(require, "null-ls")
    if null_ls_s then
        local sources = null_ls.get_sources()
        for _, source in ipairs(sources) do
            if source._validated then
                for ft_name, ft_active in pairs(source.filetypes) do
                    if ft_name == buf_ft and ft_active then
                        table.insert(buf_client_names, source.name)
                    end
                end
            end
        end
    end

    -- Add linters (from nvim-lint)
    local lint_s, lint = pcall(require, "lint")
    if lint_s then
        for ft_k, ft_v in pairs(lint.linters_by_ft) do
            if type(ft_v) == "table" then
                for _, linter in ipairs(ft_v) do
                    if buf_ft == ft_k then
                        table.insert(buf_client_names, linter)
                    end
                end
            elseif type(ft_v) == "string" then
                if buf_ft == ft_k then
                    table.insert(buf_client_names, ft_v)
                end
            end
        end
    end

    -- Add formatters (from formatter.nvim)
    local formatter_s, _ = pcall(require, "formatter")
    if formatter_s then
        local formatter_util = require("formatter.util")
        for _, formatter in ipairs(formatter_util.get_available_formatters_for_ft(buf_ft)) do
            if formatter then
                table.insert(buf_client_names, formatter)
            end
        end
    end

    -- This needs to be a string only table so we can use concat below
    local unique_client_names = {}
    for _, client_name_target in ipairs(buf_client_names) do
        local is_duplicate = false
        for _, client_name_compare in ipairs(unique_client_names) do
            if client_name_target == client_name_compare then
                is_duplicate = true
            end
        end
        if not is_duplicate then
            table.insert(unique_client_names, client_name_target)
        end
    end

    local client_names_str = table.concat(unique_client_names, ", ")
    local language_servers = string.format("[%s]", client_names_str)

    return language_servers
end

local attached_clients = {
    get_attached_clients,
    color = {
        gui = "bold"
    }
}

return {
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },

        config = function()
            require("bufferline").setup {}
        end
    },
    {
        "dgox16/oldworld.nvim",
        lazy = true,
    },
    -- lazy.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                cmdline = {
                    enabled=true,
                    view = "cmdline",
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = false,
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false,       -- add a border to hover docs and signature help
                },
            })
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "sainnhe/gruvbox-material",
        },
        config = function()
            -- gruvbox-material ships its palette as vimscript only; get_configuration()
            -- picks up the vim.g options set in colors.lua (hard background, mix fg).
            local conf = vim.fn["gruvbox_material#get_configuration"]()
            local p = vim.fn["gruvbox_material#get_palette"](conf.background, conf.foreground, conf.colors_override)

            -- [1] is the gui hex, [2] the cterm index.
            local colors = {
                bg = p.bg0[1],
                bg_dark = p.bg_dim[1],
                fg = p.fg1[1],
                red = p.red[1],
                orange = p.orange[1],
                yellow = p.yellow[1],
                green = p.green[1],
                cyan = p.aqua[1],
                blue = p.blue[1],
                purple = p.purple[1],
                gray2 = p.bg5[1],
            }
            local bar_bg = p.bg_statusline1[1]

            local modecolor = {
                n = colors.red,
                i = colors.cyan,
                v = colors.purple,
                ["\22"] = colors.purple,
                V = colors.red,
                c = colors.yellow,
                no = colors.red,
                s = colors.yellow,
                S = colors.yellow,
                ic = colors.yellow,
                R = colors.green,
                Rv = colors.purple,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ["r?"] = colors.cyan,
                ["!"] = colors.red,
                t = colors.blue,
            }

            -- Only section a varies by mode; b/c/z are shared.
            local theme = {}
            for mode, accent in pairs({
                normal = colors.blue,
                insert = colors.orange,
                visual = colors.green,
                replace = colors.green,
            }) do
                theme[mode] = {
                    a = { fg = colors.bg_dark, bg = accent },
                    b = { fg = colors.fg, bg = p.bg_statusline3[1] },
                    c = { fg = colors.fg, bg = bar_bg },
                    z = { fg = colors.fg, bg = bar_bg },
                }
            end

            local space = {
                function()
                    return " "
                end,
                color = { bg = bar_bg, fg = colors.blue },
            }

            local filename = {
                "filename",
                color = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                separator = { left = "", right = "" },
            }

            local branch = {
                "branch",
                icon = " ",
                color = { bg = colors.green, fg = colors.bg, gui = "bold" },
                separator = { left = "", right = "" },
            }

            local location = {
                "location",
                color = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
                separator = { left = "", right = "" },
            }

            local diff = {
                "diff",
                color = { bg = colors.gray2, fg = colors.bg, gui = "bold" },
                separator = { left = "", right = "" },
                symbols = { added = " ", modified = " ", removed = " " },
                colored = true,

                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.yellow },
                    removed = { fg = colors.red },
                },
            }

            local modes = {
                "mode",
                color = function()
                    -- mode(1) so the multi-char keys (no, ic, Rv, ...) can actually match.
                    -- Unlisted long modes (nt, niI, Rc, ...) fall back to their first char.
                    local m = vim.fn.mode(1)
                    local bg = modecolor[m] or modecolor[m:sub(1, 1)] or colors.blue
                    return { bg = bg, fg = colors.bg_dark, gui = "bold" }
                end,
                separator = { left = "", right = "" },
            }

            local macro = {
                function()
                    -- Extract "@x" from "recording @x"; noice can report other modes.
                    local mode = require("noice").api.status.mode.get()
                    local reg = mode and mode:match("@%w")
                    return reg and (" " .. reg) or ""
                end,
                cond = function()
                    -- pcall: an uninstalled module here blanks the whole statusline, not just this pill.
                    local ok, noice = pcall(require, "noice")
                    return ok and noice.api.status.mode.has()
                end,
                color = { fg = colors.red, bg = bar_bg, gui = "italic,bold" },
            }

            local dia = {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },

                diagnostics_color = {
                    error = { fg = colors.red },
                    warn = { fg = colors.yellow },
                    info = { fg = colors.purple },
                    hint = { fg = colors.cyan },
                },
                color = { bg = colors.gray2, fg = colors.blue, gui = "bold" },
                separator = { left = "", right = "" },
                always_visible = true,
            }

            -- Every Claude agent on the machine, not just this nvim's sidekick.
            -- Requires lazily inside the functions so lualine can set up before
            -- claude-sessions.nvim has loaded (lazy.nvim loads it on require).
            local claude = {
                function()
                    return require("claude-sessions").status()
                end,
                cond = function()
                    local ok, sessions = pcall(require, "claude-sessions")
                    return ok and sessions.has_sessions()
                end,
                color = { bg = bar_bg },
                padding = 1,
            }

            require("lualine").setup({
                options = {
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
                    icons_enabled = true,
                    theme = theme,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },

                sections = {
                    lualine_a = {
                        modes,
                    },
                    lualine_b = {
                        space,
                    },
                    lualine_c = {
                        branch,
                        space,
                        filename,
                    },
                    lualine_x = { claude },
                    lualine_y = { macro },
                    lualine_z = {
                        diff,
                        space,
                        location,
                        space,
                        dia,
                    },
                },

                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
            vim.o.laststatus = vim.g.lualine_laststatus
        end
    }
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     config = function()
    --         require("lualine").setup({
    --             options = { theme = 'onedark' },
    --             sections = {
    --                 lualine_x = { "diagnostics", attached_clients, "filetype" }
    --             }
    --         })
    --     end
    -- }
}
