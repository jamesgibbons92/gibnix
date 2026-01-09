{config, ...}: {
  networking.hosts = {
    "127.0.0.1" = ["syncthing"];
  };

  services.nginx = {
    enable = true;
    virtualHosts."syncthing" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 80;
        }
      ];
      serverName = "syncthing";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
        '';
      };
    };
  };

  services.syncthing = {
    enable = true;
    user = "james";
    dataDir = "/home/james/Sync";
    configDir = "/home/james/.config/syncthing";
    # These are false so we can edit freely in the gui after the initial launch
    # Homelab is an introducer which we can then use to add the other nodes.
    overrideDevices = false;
    overrideFolders = false;
    guiAddress = "127.0.0.1:8384";
    settings = {
      gui = {
        insecureSkipHostCheck = true;
      };
      devices = {
        "homelab" = {
          id = "IP2WGJC-CY7LDYV-QAM24HD-5BWYYCO-ZH6OCEW-UUAQWNY-AKFYFGO-5GFXHQX";
          addresses = ["tcp://homelab.bobcat-mirfak.ts.net:22000"];
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
