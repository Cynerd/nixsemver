# Nix Semantic Versioning library

This provides utility functions for working with semantic versions numbers.
Please see [semantic versioning](https://semver.org/) to understand what is
going on here.


## Usage

This repository requires you to use Nix Flakes. You need to include it as Nix
Flake input to get access to the library. Afterwards you can just use the
provided functions.

```nix
inputs = {
  nixsemver = "gitlab:cynerd/nixsemver";
};

outputs = {
  nixsemver,
  ...
}: let
  inherit (nixsemver.lib) version changelog;
```


## Working with semantic version

The core functions provided by this repository.

### `semverValid s`

Validate given string that it matches valid semantic version.

### `semverSplit s`

Split string with semantic version to attribute set with fields:

* `major` with major version number
* `minor` with minor version number
* `patch` with patch version number
* `preRelease` with pre-release string
* `build` with build identifier string

### `semverToString attr`

Reverse operation for the `semverSplit`.


## Working with changelog file

This is convenient addition to also extract versions from `CHANGELOG.md` file
that is maintained according to the [Keep a
Changelog](https://keepachangelog.com/).

### `changelog.releases p`

Returns list of releases that are recorded in the changelog file on provided
path.

### `changelog.latestRelease list`

Returns the latest release and thus it skips `Unreleased` and instead provides
the one right after it. The default is `0.0.0` if there is no release yet.

Note that this relies on the ordering in the changelog and thus it won't look
for actually semantically newest version.

### `changelog.getLatestRelease p`

Combination of `changelog.releases` and `changelog.latestRelease` and thus it
provides latest release from changelog file on provided path.
