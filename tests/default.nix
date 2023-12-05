check: lib: let
  inherit (builtins) readDir;
  inherit
    (lib)
    removePrefix
    removeSuffix
    hasSuffix
    hasPrefix
    mapAttrs'
    nameValuePair
    filterAttrs
    ;

  suiteName = n: removePrefix "test_" (removeSuffix ".nix" n);
  isTestFile = n: t: t == "regular" && hasSuffix ".nix" n && hasPrefix "test_" n;
in
  mapAttrs' (n: _: nameValuePair (suiteName n) (check (import (./. + "/${n}") lib)))
  (filterAttrs isTestFile (readDir ./.))
