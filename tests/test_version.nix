lib: let
  inherit (builtins) toString;

  params = [
    {
      str = "1.2.3";
      attr = {
        major = 1;
        minor = 2;
        patch = 3;
        preRelease = null;
        build = null;
      };
    }
    {
      str = "12.426.16309-alpha.8";
      attr = {
        major = 12;
        minor = 426;
        patch = 16309;
        preRelease = "alpha.8";
        build = null;
      };
    }
    {
      str = "1.8.12+pl";
      attr = {
        major = 1;
        minor = 8;
        patch = 12;
        preRelease = null;
        build = "pl";
      };
    }
    {
      str = "1.8.12-alpha.9+pl";
      attr = {
        major = 1;
        minor = 8;
        patch = 12;
        preRelease = "alpha.9";
        build = "pl";
      };
    }
  ];

  apply = name: f: params: lib.listToAttrs (lib.imap1 (i: v: lib.nameValuePair "test${name}${toString i}" (f v)) params);
in
  (apply "SemverValid" (p: {
      expr = lib.semverValid p.str;
      expected = true;
    })
    params)
  // (apply "SemverSplit" (p: {
      expr = lib.semverSplit p.str;
      expected = p.attr;
    })
    params)
  // (apply "SemverToString" (p: {
      expr = lib.semverToString p.attr;
      expected = p.str;
    })
    params)
