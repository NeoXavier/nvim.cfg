return {
  {
    "sheng-tse/jupynvim",
    -- Must load eagerly: setup() registers the BufReadCmd that hijacks *.ipynb
    -- opens, and that has to exist *before* the buffer is read. Any ft/event
    -- trigger fires too late (and Neovim calls .ipynb files "json" anyway).
    lazy = false,
    build = function(plugin)
      local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
      install.run(plugin)
    end,
    opts = {
      log_level = "info",
      image_renderer = "placeholder",  -- kitty graphics w/ unicode placeholders
      max_output_lines = 500,
    },
  },
}
