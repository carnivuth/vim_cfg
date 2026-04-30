-- telescope
vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files <cr>')
vim.keymap.set('n', '<Leader>fm', '<cmd>Telescope markdown_frontmatter <cr>')
vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope git_files <cr>')
vim.keymap.set('n', '<Leader>l', '<cmd>Lazy <cr>')
vim.keymap.set('n', '<Leader>Vr', '<cmd>source $MYVIMRC<cr>')
vim.keymap.set('n', '<Leader>Ve', '<cmd>e $MYVIMRC<cr>')
vim.keymap.set('n', '<Leader>z', '<cmd>ZenMode<cr>')

-- common commands for buffers
vim.keymap.set('n', '<Leader>q', '<cmd>quit<cr>')
vim.keymap.set('n', '<Leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<Leader>c', '<cmd>bw<cr>')
vim.keymap.set('n', '<Leader>j', '<cmd>bnext<cr>')
vim.keymap.set('n', '<Leader>k', '<cmd>bprevious<cr>')
vim.keymap.set('n', '<Leader>gg', '<cmd>LazyGit<cr>')
vim.keymap.set('i', 'jj', '<Esc>')

-- keep cursor on center when scrolling files
vim.keymap.set('n', '<Leader>n', 'nzz')
vim.keymap.set('n', '<Leader>N', 'Nzz')
vim.keymap.set('n', '<Leader>{', '{zz')
vim.keymap.set('n', '<Leader>}', '}zz')
vim.keymap.set('n', '<Leader>(', '(zz')
vim.keymap.set('n', '<Leader>)', ')zz')
vim.keymap.set('n', '<Leader>[', '[zz')
vim.keymap.set('n', '<Leader>]', ']zz')
vim.keymap.set('n', '<Leader>n', 'nzz')
vim.keymap.set('n', '<Leader><C-d>', '<C-d>zz')
vim.keymap.set('n', '<Leader><C-u>', '<C-u>zz')

-- add elements to begining and endig of a visual highlighted block
vim.keymap.set('v', '`', '<Esc>`>a`<Esc>`<i`<Esc>')
vim.keymap.set('v', '"', '<Esc>`>a"<Esc>`<i"<Esc>')
vim.keymap.set('v', '(', '<Esc>`>a)<Esc>`<i(<Esc>')
vim.keymap.set('v', '[', '<Esc>`>a]<Esc>`<i[<Esc>')
