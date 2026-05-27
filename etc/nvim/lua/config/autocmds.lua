vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- lint jenkinsfiles on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "Jenkinsfile" },
  callback = function ()
    require("jenkinsfile_linter").validate()
  end
})
--vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--  pattern = { "*" },
--  command = [[normal mfggVG=`f]],
--})
