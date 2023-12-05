_: super: let
  inherit (builtins) match elemAt toString;
  inherit (super) head toIntBase10;

  semverRegex = "(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(-((0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\\+([0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*))?";
in {
  /*
  Validate the semantic version string.

  Example:
    semverValid "1.2.3-alpha+docker"
    => true
    semverValid "1.2.3+alpha+docker"
    => false
  */
  semverValid = s: match semverRegex s != null;

  /*
  Split semantic version to its components.

  Example:
    semverSplit "1.2.3-alpha+docker"
    => {major = 1; minor = 2; patch = 3; preRelease = "alpha"; build = "docker";}
  */
  semverSplit = s: let
    v = match semverRegex s;
  in {
    major = toIntBase10 (elemAt v 0);
    minor = toIntBase10 (elemAt v 1);
    patch = toIntBase10 (elemAt v 2);
    preRelease = elemAt v 4;
    build = elemAt v 9;
  };

  /*
  Convert semantic version to its string representation.

  Example:
    semverToString {major = 1; minor = 2; patch = 3; preRelease = "alpha"; build = "docker";}
    => "1.2.3-alpha+docker"
  */
  semverToString = semver:
    with semver;
      "${toString major}.${toString minor}.${toString patch}"
      + (super.optionalString (preRelease != null) "-${preRelease}")
      + (super.optionalString (build != null) "+${build}");
}
