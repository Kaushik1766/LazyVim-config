-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w") -- Save

  local filename = vim.fn.expand("%:p") -- full path
  local output = vim.fn.expand("%:p:r") -- without extension

  -- Compile
  vim.fn.jobstart({ "g++", filename, "-o", output }, {
    stdout_buffered = true,
    on_exit = function(_, code)
      if code == 0 then
        -- Open a floating terminal and run
        vim.cmd("botright 10split | term " .. output)
      else
        vim.notify("Compilation failed!", vim.log.levels.ERROR)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
  })
end, { noremap = true, silent = true })
