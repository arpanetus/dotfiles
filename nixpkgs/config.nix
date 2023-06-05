{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
 
  permittedInsecurePackages = [
    "nodejs-16.20.0"
  ];
}
