{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = (ps: with ps; [
      pynvim
    ]);
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };

  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
