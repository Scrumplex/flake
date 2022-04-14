let
  scrumplex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpOdVBegpAd9XSOaFKaRks512vkskrOAuBPbQkl0Bab scrumplex@andromeda";

  spacehub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPLNX2+TkwkR92aSmNw8faKt4DO58EJkJrBk//MEHrf";
  duckhub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINo54AduiP0MDvRS35SeEV0Wi1Nlszo3enR/xVJtGQaX";
in
{
  "spacehub/id_borgbase.age".publicKeys = [ scrumplex spacehub ];
  "spacehub/wireguard.key.age".publicKeys = [ scrumplex spacehub ];
  "duckhub/id_borgbase.age".publicKeys = [ scrumplex duckhub ];
  "duckhub/wireguard.key.age".publicKeys = [ scrumplex duckhub ];
}
