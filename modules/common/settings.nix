{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    settings = {
      name = mkOption {
        default = "TJ Maynes";
        type = with types; uniq str;
      };
      username = mkOption {
        default = "tjmaynes";
        type = with types; uniq str;
      };
      email = mkOption {
        default = "tj@tjmaynes.com";
        type = with types; uniq str;
      };
      description = mkOption {
        default = "TJ Maynes";
        type = with types; uniq str;
      };
      gitUsername = mkOption {
        default = "tjmaynes";
        type = with types; uniq str;
      };
      hostname = mkOption {
        default = "kubrick";
        type = with types; uniq str;
      };
      timeZone = mkOption {
        default = "America/Chicago";
        type = with types; uniq str;
      };
      fontName = mkOption {
        default = "Inconsolata";
        type = with types; uniq str;
      };
      fontSize = mkOption {
        default = 12.0;
        type = types.float;
      };
      terminal = mkOption {
        default = "alacritty";
        type = with types; uniq str;
      };
      onlyHomeManager = mkOption {
        default = false;
        type = types.boolean;
      };
    };
  };
}
