currentPlatform: {lib, ...}: let
  inherit (builtins) pathExists readDir;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten optional optionals;

  /*
  Return a module in a sub directory of the current path, if it exists.

  Path -> String -> List
  */
  findNestedModule = directory: moduleName: let
    localPath = childPath: ./${childPath};
    rolePath = localPath "${directory}/${moduleName}.nix";
  in
    optional (pathExists rolePath) rolePath;

  /*
  Return a list of all nested modules in a given directory including nested platform modules.

  String -> Path -> List
  */
  mkRoles = currentPlatform: currentDir: let
    findRoles = name: type:
      optionals (type == "directory")
      ([./${name}] ++ findNestedModule name currentPlatform);
  in
    flatten (mapAttrsToList findRoles currentDir);
in {
  imports = mkRoles currentPlatform (readDir ./.);
}
