{lib, ...}: {
  imports = [
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" "scrumplex"])
    (lib.mkAliasOptionModule ["primaryUser"] ["users" "users" "scrumplex"])
  ];
}
