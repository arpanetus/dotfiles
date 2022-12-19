# checks the existence of clipboard tool if the host is wsl and has neovim

if test -e $HOME/.nix-profile/bin/nvim && grep -qi 'microsoft' /proc/version && not test -e /usr/local/bin/win32yank.exe
    printf "%s\n"                   \
           "you need to install win32yank in order to make clipboard work for nvim:" \
           " " \
           "# run powershell"         \
           "powershell.exe "          \
           " " \
           "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time " \
           "irm get.scoop.sh | iex  " \
           "scoop install win32yank " \
           "# copy the output       " \
           "scoop which win32yank   " \
           "exit                    " \
           " " \
           "sudo ln -s \"/mnt/c/Users/<Username>/scoop/apps/win32yank/current/win32yank.exe\" \"/usr/local/bin/win32yank.exe\" "
end
  

