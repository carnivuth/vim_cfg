-- hyprlang
vim.filetype.add({pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },})

-- ansible
vim.filetype.add({pattern = { [".*%.playbook.yml"] = "ansible" },})
vim.filetype.add({pattern = { [".*%.playbook.yaml"] = "ansible" },})
vim.filetype.add({pattern = { [".*/playbooks/.*%.yml"] = "ansible" },})
vim.filetype.add({pattern = { [".*/playbooks/.*%.yaml"] = "ansible" },})
vim.filetype.add({pattern = { [".*/roles/.*%.yml"] = "ansible" },})
vim.filetype.add({pattern = { [".*/roles/.*%.yaml"] = "ansible" },})

-- treesitter language configurations
vim.treesitter.language.register("yaml",{"ansible"})
