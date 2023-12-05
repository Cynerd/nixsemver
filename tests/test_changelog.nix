lib: {
  testReleases = {
    expr = lib.changelog.releases ./test_changelog.md;
    expected = ["Unreleased" "1.1.0" "1.0.0" "0.1.1" "0.1.0"];
  };

  testLatestRelease = {
    expr = lib.changelog.latestRelease ["1.0.0" "1.1.0" "0.1.0"];
    expected = "1.0.0";
  };
  testLatestReleaseUnreleased = {
    expr = lib.changelog.latestRelease ["Unreleased" "1.1.0" "0.1.0"];
    expected = "1.1.0";
  };
  testLatestReleaseNoRelease = {
    expr = lib.changelog.latestRelease ["Unreleased"];
    expected = "0.0.0";
  };

  testGetLatestRelease = {
    expr = lib.changelog.getLatestRelease ./test_changelog.md;
    expected = "1.1.0";
  };
}
