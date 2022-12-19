# dotfiles

# WSL
 - enable Hyper-V & WSL:
    ```PowerShell   
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    wsl.exe --set-default-version 2
    ```
 - install Alpine from [Microsoft Store](https://apps.microsoft.com/store/detail/alpine-wsl/9P804CRF0395?) (I have some concerns about its legitimacy, but it is what it is).
 - install sudo & add sudo group:
    ```sh
    # log into root & add sudo
    su -
    apk add --no-cache sudo
    echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
    
    adduser $username wheel 
    passwd $username
    exit
    ```
- install prerequisite for nix:
    ```sh
    sudo apk add --no-cache curl xz
    ```
- install nix:
    ```sh
    # no-daemon is a single-user installation, since wsl doesn't support systemd. 
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    ```
    there might be some issues with required nix group not being present, so for it:
    ```sh
    addgroup nixbld
    usermod -aG nixbld $username
    ``` 
- install home-manager:
    ```sh
    nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```
- install `git` to fetch dotfiles:
    ```sh
    nix-env -i git
    git clone https://github.com/arpanetus/dotfiles
    ```
- install the nix config:
    ```sh
    # remove the default config
    rm ~/.config/nixpkgs/home.nix

    # symlink the fetched config
    cd dotfiles
    ln -s $(pwd)/nixpkgs $HOME/.config/nixpkgs

    # let the home-manager do its deeds
    home-manager switch
    ```
- set fish as default terminal:
    ```sh
    su -
    cd /home/$username
    echo "$(pwd)/.nix-profile/bin/fish" >> /etc/shells
    chsh -s $(pwd)/.nix-profile/bin/fish
    ```

i very much thank [Chris Bailey](https://cbailey.co.uk/posts/a_minimal_nix_development_environment_on_wsl) for his tutorial, 
[Lily Ballard](https://github.com/lilyball/nix-env.fish) for her fish config, and [Christian Chiarulli](https://github.com/LunarVim/Neovim-from-scratch)
for his video series on Neovim from scratch.
