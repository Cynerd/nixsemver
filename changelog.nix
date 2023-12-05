_: super: let
  inherit (builtins) split elemAt filter isList;
  inherit (super) fileContents head flatten;
in rec {
  /*
  Returns list of releases that are recorded in the changelog fiel provided.

  Example:
    releases ./CHANGELOG.md
    => ["Unreleasead" "1.0.0" "0.1.0"]
  */
  releases = p: flatten (filter isList (split "\n## \\[([^]]*)]" (fileContents p)));

  /*
  Returns the latest release and thus it skips Unreleased and instead provides
  the one right after it. The default is 0.0.0 if there is no release yet.

  Example:
    latest_release ["Unreleased" "1.0.0" "0.1.0" ]
    => "1.0.0"
    latest_release ["1.0.0" "1.0.1" "0.1.0"]
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
    get_latest_release ./CHANGELOG.md
    => "1.0.0"
  */
  getLatestRelease = p: latestRelease (releases p);
}
