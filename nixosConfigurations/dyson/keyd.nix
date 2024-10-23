{...}: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["0001:0001"];
        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
    };
  };
}
