{...}: {
  hardware.bluetooth = {
    enable = true;
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
