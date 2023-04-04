{
  description = "Home Manager configuration of kai";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, darwin, home-manager, neovim-nightly-overlay, ... }:
    let 
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          neovim-nightly-overlay.overlay
        ];
      };
    in
    {
      darwinConfigurations = {
        blankspace = darwin.lib.darwinSystem {
        inherit system pkgs;
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kai = import ./home.nix;
        
            # Optionally use extraSpecialArgs
            # to pass through arguments to home.nix
            home-manager.extraSpecialArgs = {};
          }
       ];
      };
     };
  };
}
