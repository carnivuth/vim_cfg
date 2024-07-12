# TOOLBOX

personal toolbox aimed at python,bash and ansible programming.

## GOALS

- **portability**: these configurations are meant to be used in any possible environment (*from personal desktops to remote, terminal only machines*)  and any possible os (*primarly arch, ubuntu and debian at the leatest versions*)
- **plugin-less**: avoid to depend on external plugins 
- **simplicity**: quick, easy installation and update procedures

## DEPENDENCIES

for the base functionality, these programs are required

- `vim` main program
- `lazygit` for advanced git interaction
- `fzf` for quick file opening
- `tmux` for multiple session and project management

wayland specific:

- `wl-clipboard` for clipboard copypaste shortcuts (*remote servers not supported*)

for lsp functionalities:

- `vim-ale` for lsp features and code analisys
- `vim-ansible` for playbooks and role linting
- `pyright` for python stuff
- `gopls` for go programs


## INSTALLATION

- clone repository

```bash
git clone https://github.com/carnivuth/vim_cfg
```

- run make

```
cd vim_cfg
make 
```

the makefile creates a link in `$HOME/.vim` to this directory, the installation can also be performed by creating manually the link:  

```bash
ln -s path/to/repo/ ~/.config/vim
```

or you can also run vim by setting the configuration file

```bash
vim -u path/to/repo/vimrc
```

### DEBIAN

for debian distros fzf main vim function need to be linked manually

```bash
mkdir -p /usr/share/vim/vimfiles/plugin/
ln -s /usr/share/doc/fzf/examples/plugin/fzf.vim /usr/share/vim/vimfiles/plugin/
```

## UNINSTALL 

- run make

```bash
cd vim_cfg
make uninstall
```

## UPDATE

- run make

```bash
cd vim_cfg
make update
```
