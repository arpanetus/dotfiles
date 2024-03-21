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
      ofMap (mapped // { ${p.fst}.source = ./. + "/neovim/" + (rp "." p.snd); }) (tail pairs);
in
{
  # Support for flakes.
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      # Haskell.nix binary cache.
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "cache.iog.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];
      substituters = [
        "https://cache.iog.io"
        "https://iohk.cachix.org"
        "https://cache.nixos.org/"
      ];
    };
  };

  # NUR repository.
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import <nur> {
      inherit pkgs;
    };
  };

  nixpkgs.config.allowUnfree = true;

  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;
  # services.vscode-server.enableFHS = true;
  services.vscode-server.installPath = "~/.vscode-server-oss";

  # services.vscode-server = {
  #   enable = true;
  #   installPath = "~/.vscode-server-oss";
  # #   postPatch = ''
  # #     bin=$1
  # #     bin_dir=${config.services.vscode-server.installPath}/bin/$bin
  # #     mkdir -p $bin_dir
  # #     cp $bin $bin_dir
  # #     chmod +x $bin_dir/$bin
  # #
  # # '';
  #   extraRuntimeDependencies = pkgs: with pkgs; [
  #     curl
  #     python311
  #   ];
  #
  # };
  # nixpkgs.overlays = [
  #   (final: prev:
  #   let
  #     toolNames = ["goland"];
  #     makeToolOverlay = toolName: {
  #       ${toolName} = prev.jetbrains.${toolName}.overrideAttrs (old: {
  #         patches = (old.patches or []) ++ [ ./JetbrainsRemoteDev.patch ];
  #         installPhase = (old.installPhase or "") + ''
  #           makeWrapper "$out/$pname/bin/remote-dev-server.sh" "$out/bin/$pname-remote-dev-server" \
  #             --prefix PATH : "$out/libexec/$pname:${final.lib.makeBinPath [ final.jdk final.coreutils final.gnugrep final.which final.git ]}" \
  #             --prefix LD_LIBRARY_PATH : "${final.lib.makeLibraryPath ([ final.stdenv.cc.cc.lib final.libsecret final.e2fsprogs final.libnotify ])}" \
  #             --set-default JDK_HOME "${final.jetbrains.jdk}" \
  #             --set-default JAVA_HOME "${final.jetbrains.jdk}"
  #         '';
  #       });
  #     };
  #   in { jetbrains = prev.jetbrains // builtins.foldl' (acc: toolName: acc // makeToolOverlay toolName) {} toolNames; })
  # ];

  # # Binary Cache for Haskell.nix  
  # nix.binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
  # nix.binaryCaches = [ "https://cache.iog.io" ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "arpanetus";
  home.homeDirectory = "/home/arpanetus";


  # users.users.arpanetus.extraGroups = [ "docker" ];

  # Packages that should be installed to the user profile.
  # Figure out how to deamonize docker, tmux for WSL.
  home.packages = with pkgs; [
    # Basic tools.
    git
    wget
    curl
    tmux
    openssh
    tree
    whois
    gnupatch
    cmake
    gnumake
    gzip

    # Monitoring.
    htop
    neofetch

    # Dev.
    awscli2
    docker
    docker-compose
    kubectl
    niv
    google-cloud-sdk

    # Programming languages.
    gcc
    go_1_21
    python311
    # mach-nix  # Python envs.
    # dream2nix

    node2nix
    nodejs
    deno
    yarn

    ocaml
    ocamlformat

    rustup
    tree-sitter
    perl
    niv

    # Formatters & Linters.
    stylua
    shellcheck
    shfmt
    vale
    nodePackages.prettier
    sumneko-lua-language-server # Lua.

    alejandra # Nix.
    nixfmt # Nix.
    nil # Nix.
    rnix-lsp # Nix. 

    # rust-analyzer # Rust

    ripgrep
    fd

    gopls
    gofumpt
    golangci-lint
    gotools

    ## Figure out how to properly install.
    # clang 
    # haskell


    jetbrains.goland
    jetbrains.jdk 

    palemoon-bin
  ];


  home.sessionVariables = {
    WORDLIST = "${pkgs.scowl}/share/dict/words.txt";
    GDK_SCALE = 2;
  };

  programs.ssh.enable = true;

  # programs.gcloud.packages = with pkgs; [
  #   (google-cloud-sdk.withExtraComponents ([
  #     google-cloud-sdk.components.cloud-build-local
  #   ]))
  # ];

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

  programs.lazygit.enable = true;

  home.file = ofMap
    {
      ".vale.ini" = { source = ./neovim/.vale.ini; };
      ".config/fish/conf.d/nix-env.fish" = { source = ./fish/conf.d/nix-env.fish; };
      ".config/fish/conf.d/nvim.fish" = { source = ./fish/conf.d/nvim.fish; };
      ".config/fish/conf.d/gopath.fish" = { source = ./fish/conf.d/gopath.fish; };
      ".config/fish/conf.d/fish_prompt.fish" = { source = ./fish/conf.d/fish_prompt.fish; };
      ".config/fish/conf.d/alias.fish" = { source = ./fish/conf.d/alias.fish; };
      ".config/fish/functions/envsource.fish" = { source = ./fish/functions/envsource.fish; };
    }
    (pkgs.lib.lists.zipLists sources nvimFiles);

  programs.opam = {
    enable = true;
    enableFishIntegration = true;
  };

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
      copilot-lua
    ];

    extraPackages = with pkgs; [
      gcc
      sqlite
      # nodejs-16_x # for Copilot.

      alejandra # Nix.
      nixfmt # Nix.
      nil
      rnix-lsp

      sumneko-lua-language-server
      stylua # Lua

      vscode-langservers-extracted

      # rust-analyzer # Rust

      gcc
      black

      pyright
      ripgrep
      fd

      gopls
      gofumpt
      go_1_21
      golangci-lint
      gotools

      ocamlformat
      wget

      python311Packages.python-lsp-server
    ];
  };

  programs.fish.enable = true;
}
