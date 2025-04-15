final: prev: let
  inherit (builtins) split elemAt filter isList;
  inherit (prev) fileContents head flatten optionalString;
  inherit (final) semverSplit semverToString;
in {
  changelog = {
    /*
    Returns list of releases that are recorded in the changelog fiel provided.

    Example:
      releases ./CHANGELOG.md
      => ["Unreleased" "1.0.0" "0.1.0"]
    */
    releases = p: flatten (filter isList (split "\n## \\[([^]]*)]" (fileContents p)));

    /*
    Returns the latest release and thus it skips Unreleased and instead provides
    the one right after it. The default is 0.0.0 if there is no release yet.

    Example:
      latestRelease ["Unreleased" "1.0.0" "0.1.0" ]
      => "1.0.0"
      latestRelease ["1.0.0" "1.0.1" "0.1.0"]
      => "1.0.0"
    */
    latestRelease = list: let
      latest = head list;
    in
      if latest == "Unreleased"
      then "${elemAt (list ++ ["0.0.0"]) 1}"
      else latest;

    /*
    Combination of releases and latest_release.

    Example:
      getLatestRelease ./CHANGELOG.md
      => "1.0.0"
    */
    getLatestRelease = p: final.changelog.latestRelease (final.changelog.releases p);

    /*
    This combines the flake's source info with changelog version to produce the
    appropriate version. The primary idea is to add short git revision to the
    pre-release field if changelog has Unreleased section.

    Example:
      currentRelease ./CHANGELOG.md self.sourceInfo
      => "1.1.0-alpha0.ae849da-dirty+docker"
    */
    currentRelease = p: sourceInfo: let
      r = final.changelog.releases p;
      lr = final.changelog.latestRelease r;
      slr = semverSplit lr;
    in
      if head r == "Unreleased" || sourceInfo ? "dirtyRev"
      then
        semverToString (slr
          // {
            preRelease =
              (optionalString (slr.preRelease
                  != null) "${slr.preRelease}.")
              + "${sourceInfo.shortRev or sourceInfo.dirtyShortRev}";
          })
      else lr;
  };
}
