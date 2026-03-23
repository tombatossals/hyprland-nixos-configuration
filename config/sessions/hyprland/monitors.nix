{ config, lib, ... }:

{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1080@144, 0x0, 1.0"
      # Catch-all for virtual machines (UTM, QEMU, etc.)
      ", preferred, auto, 1"
    ];
  };
}
