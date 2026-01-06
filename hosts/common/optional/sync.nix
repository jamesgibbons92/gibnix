{config, ...}: {
  services.syncthing = {
    enable = true;
    user = "james";
    dataDir = "/home/james/Sync";
    configDir = "/home/james/.config/syncthing";
    # These are false so we can edit freely in the gui after the initial launch
    # Homelab is an introducer which we can then use to add the other nodes.
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      devices = {
        "homelab" = {
          id = "IP2WGJC-CY7LDYV-QAM24HD-5BWYYCO-ZH6OCEW-UUAQWNY-AKFYFGO-5GFXHQX";
          addresses = ["tcp://homelab:22000"];
          introducer = true;
          autoAcceptFolders = false;
        };
      };
      folders = {
        "sync" = {
          id = "v5mkt-3czwf";
          label = "sync";
          path = "~/Sync";
          type = "sendreceive";
          rescanIntervalS = 3600;
          fsWatcherEnabled = true;
          devices = ["homelab"];
          versioning = {
            type = "simple";
            params = {
              cleanIntervalS = "3600";
              maxAgeS = "2592000";
              maxVersions = "10";
            };
          };
        };
      };
      options = {
        urAccepted = -1;
        startBrowser = true;
        # Disable all discovery
        natEnabled = false;
        relaysEnabled = false;
        localAnnounceEnabled = false;
        globalAnnounceEnabled = false;
      };
    };
  };
}
