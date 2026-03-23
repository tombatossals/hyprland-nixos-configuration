{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Use an actual monospace Nerd Font to avoid foot warnings.
        font = "JetBrainsMono Nerd Font Mono:size=11";
      };
    };
  };
}
