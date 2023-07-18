{...}: {
  programs.waybar.extraModules.paMute.alsaState = {
    card = "Generic"; # TODO: is there a more unique identifier?
    file = ./asound.state;
  };
}
