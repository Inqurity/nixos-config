{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      display = {
        separator = "";
      };
      logo = {
        source = "~/.config/fastfetch/logo.txt";
        type = "file";
        color = {
            "1" = "blue";
            "2" = "cyan";
            "3" = "magenta";
            "4" = "white";
        };
      };

      modules = [
        {
          type = "custom";
          outputColor = "38;2;255;255;0";
          keyColor = "38;2;255;255;0";
          format = "▍▍▍ ▍▍▍▍ ▍▍ ▍▍▍▍▍▍";
        } {
          type = "title";
          outputColor = "38;2;255;255;0";
          keyColor = "38;2;255;255;0";
          format = "!!__{1}@{2}__!!";
        }
        "break"
        {
          type = "custom";
          outputColor = "38;2;255;255;0";
          keyColor = "38;2;255;255;0";
          format =  "::RESPONSIVE THOUGHTFORM::";
        } {
          type = "custom";
          outputColor = "38;2;255;255;0";
          keyColor = "38;2;255;255;0";
          format =  "::EXPLICIT PURPOSE::'SYSTEM MANAGEMENT'";
        } {
          type = "custom";
          outputColor = "38;2;255;255;0";
          keyColor = "38;2;255;255;0";
          format =  "::INHERITED CONTEXT::{#38;2;255;0;255}'it has formed its own eyes'";
        } {
          type = "custom";
          outputColor = "38;2;255;0;255";
          keyColor = "38;2;255;0;255";
          format =  "::INCOHERENCE DETECTED";
        } {
          type = "os";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'{2}'";
        } {
          type = "host";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'{2}'";
        } {
          type = "kernel";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'{2}'";
        } {
          type = "uptime";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'has been awake for {?2}{2} winks and {?}{3} gazes'";
          #"format = "'awake for {?1}{1} gazes, {?}{?2}{2} winks and {?}{3} blinks'"
        } {
          type = "shell";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'{1} {4}'";
        } {
          type = "display";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'display {6} {1}x{2} @ {3} Hz'";
        } {
          type = "de";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'{1}'";
        } {
          type = "wm";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'{2} ({3})'";
        } {
          type = "wmtheme";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'wm theme {1}'";
        } {
          type = "theme";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'theme {1}'";
        } {
          type = "icons";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'icons {1}'";
        } {
          type = "font";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'font {5}'";
        } {
          type = "cursor";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'cursor {1}'";
        } {
          type = "terminal";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'mindspike {5}'";
        } {
          type = "terminalfont";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'mindspike font {1}'";
        } {
          type = "cpu";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'cpu {2} {1} ({3}) @ {7}'";
        } {
          type = "gpu";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'gpu {1} {2} {6}'";
        } {
          type = "memory";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'memory {1} / {2} ({3})'";
        } {
          type = "swap";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'swap {1} / {2} ({3})'";
        } {
          type = "disk";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'cyst {10} {1} / {2} ({3})'";
        } {
          type = "localip";
          outputColor = "38;2;255;255;0";
          key = "+";
          keyColor = "38;2;0;255;255";
          format = "'located at {1}'";
        }
      ];
    };
  };

  xdg.configFile."fastfetch/logo.txt".source = mkOutOfStoreSymlink "/etc/nixos/config/fastfetch/logo.txt";
}
