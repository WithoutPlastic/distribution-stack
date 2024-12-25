# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  #wsl.wslConf.automount.options = "metadata,uid=1000,gid=100,fmask=111,dmask=022";

  environment.systemPackages = [
    pkgs.dos2unix
    pkgs.file
    pkgs.neovim
    pkgs.vim
    pkgs.git
    pkgs.zsh
    pkgs.tmux
    pkgs.figlet
    pkgs.cowsay
    pkgs.openssh
    pkgs.pinentry-curses
    pkgs.gnupg
    pkgs.racket
    #pkgs.racket-minimal
    #pkgs.dotnet-sdk_8
    pkgs.dotnet-sdk_9
    pkgs.nodejs_23
    pkgs.deno
    pkgs.lynx
    pkgs.grml-zsh-config
    pkgs.rustc
    pkgs.cargo
    pkgs.helix
    pkgs.tokei
    pkgs.go
    pkgs.python314
    pkgs.zig
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  programs.zsh.enable = true;
  users.users.nixos.shell = pkgs.zsh;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
