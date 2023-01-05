{ config, pkgs, ... }:

with builtins; let
  # TODO: refactor, since ugly.
  hd = "${config.home.homeDirectory}/.config/nixpkgs/neovim";

  lfr = pkgs.lib.filesystem.listFilesRecursive;
  rp = pkgs.lib.strings.removePrefix;

  nvimFiles = (map (x: ".${rp hd x}") (lfr hd));
  sources = (map (x: ".config/nvim/lua/${rp "./neovim" x}") (nvimFiles));

  ofMap = mapped: pairs:
    if (length pairs) == 0 then mapped 
    else 
      let 
        p = head pairs;
      in
        ofMap (mapped // {${p.fst}.source = ./. + "/neovim/" + (rp "." p.snd);}) (tail pairs);
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "arpanetus";
  home.homeDirectory = "/home/arpanetus";

  # Packages that should be installed to the user profile.
  # Figure out how to deamonize docker, tmux for WSL.
  home.packages = with pkgs; [
    # Basic tools.
    git
    tmux
    openssh
    tree

    # Monitoring.
    htop
    neofetch

    # Dev.
    docker
    docker-compose

    # Programming languages.
    gcc
    nodejs
    python2Full
    python311
    deno

    # Formatters & Linters.
    stylua
    shellcheck
    shfmt
    vale
    nodePackages.prettier

    # LSP.
    sumneko-lua-language-server

    ## Figure out how to properly install.
    # clang 
    # haskell
  ];

  programs.ssh.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # FZF.
  programs.fzf.enable = true;
  programs.fzf.enableFishIntegration = true;
  
  home.file = ofMap {
    ".vale.ini" = {source = ./neovim/.vale.ini;};
    ".config/fish/conf.d/nix-env.fish" = {source = ./fish/conf.d/nix-env.fish;};
    ".config/fish/conf.d/nvim.fish" = {source = ./fish/conf.d/nvim.fish;};
  } (pkgs.lib.lists.zipLists sources nvimFiles);

  # Neovim HM config.
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    withNodeJs = true;
    withPython3 = true;
  
    extraConfig = ''
    lua require('config')
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      packer-nvim
      markdown-preview-nvim
    ];
  };

  programs.go.enable = true;
  programs.fish.enable = true;
}