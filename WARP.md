# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project overview
- This repo packages a minimal CLI wrapper around mtr (My Traceroute) as a MultiFlexi application. It ships as both a Debian package and an OCI image. The CLI entrypoint (mtr-multiflexi) runs mtr with JSON output and optional file persistence.

Common commands
- Build OCI image
  - make buildimage (local image)
    ```bash path=null start=null
    make buildimage
    ```
  - make buildx (multi-arch and push)
    ```bash path=null start=null
    make buildx
    ```
  - Without make
    ```bash path=null start=null
    docker build -f Containerfile -t vitexsoftware/multiflexi-mtr:latest .
    ```
- Run OCI image
  - Using env file
    ```bash path=null start=null
    make drun
    # or equivalently
    docker run --env-file example.env vitexsoftware/multiflexi-mtr:latest
    ```
  - Ad-hoc
    ```bash path=null start=null
    docker run --rm -e MTR_DESTINATION=1.1.1.1 vitexsoftware/multiflexi-mtr:latest
    docker run --rm -v "$PWD":/app -e MTR_DESTINATION=one.one.one.one -e RESULT_FILE=/app/mtr.json vitexsoftware/multiflexi-mtr:latest
    ```
- Local script run (no container)
  ```bash path=null start=null
  MTR_DESTINATION=1.1.1.1 ./mtr-multiflexi
  RESULT_FILE=report.json MTR_DESTINATION=one.one.one.one ./mtr-multiflexi
  ./mtr-multiflexi --help
  ```
- Debian packaging (as used in CI)
  - Bump changelog, then build with pbuilder integration
    ```bash path=null start=null
    dch -b -v 0.1.1 "Release notes here"
    debuild-pbuilder -i -us -uc -b
    ```
  - Inspect computed version
    ```bash path=null start=null
    dpkg-parsechangelog --show-field Version
    ```
- Install from the prebuilt repository (from README)
  ```bash path=null start=null
  sudo apt install lsb-release wget apt-transport-https bzip2
  wget -qO- https://repo.vitexsoftware.com/keyring.gpg | sudo tee /etc/apt/trusted.gpg.d/vitexsoftware.gpg
  echo "deb [signed-by=/etc/apt/trusted.gpg.d/vitexsoftware.gpg]  https://repo.vitexsoftware.com  $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/vitexsoftware.list
  sudo apt update
  sudo apt install multiflexi-mtr
  ```
- Tests and lint
  - There are no unit tests in this repo. Functional testing is done by running the CLI with MTR_DESTINATION set or by installing the built .deb and invoking mtr-multiflexi.
  - Quick functional checks
    ```bash path=null start=null
    # Local script: print JSON and count hops
    MTR_DESTINATION=1.1.1.1 ./mtr-multiflexi | jq '.report.hubs | length'

    # Container: persist to host and inspect
    docker run --rm -v "$PWD":/app -e MTR_DESTINATION=one.one.one.one -e RESULT_FILE=/app/mtr.json vitexsoftware/multiflexi-mtr:latest && jq . mtr.json
    ```
  - Optional local checks (not configured in repo):
    ```bash path=null start=null
    shellcheck mtr-multiflexi
    hadolint Containerfile
    ```

High-level architecture and structure
- Runtime CLI (mtr-multiflexi)
  - Bash script that accepts env vars:
    - MTR_DESTINATION (required) — target host/IP for tracing
    - RESULT_FILE (optional) — write JSON report to this path; otherwise prints to stdout
  - Invokes: mtr --report --json "$MTR_DESTINATION"
- Container image (Containerfile)
  - Base: debian:stable-slim; installs mtr-tiny, curl; copies mtr-multiflexi to /usr/local/bin and sets it as ENTRYPOINT.
- MultiFlexi app descriptor (multiflexi/mtr.multiflexi.app.json)
  - Metadata (name, description, homepage, topics, uuid); executable: mtr-multiflexi; environment schema for MTR_DESTINATION, RESULT_FILE, ZABBIX_KEY.
  - ociimage points to docker.io/vitexsoftware/mtr-multiflexi.
  - Note: ZABBIX_KEY is provided for MultiFlexi integration; the mtr-multiflexi script does not consume it directly.
- Debian packaging (debian/*)
  - control: Build-Depends on debhelper-compat (= 13), jq, moreutils; package Depends on mtr-tiny, multiflexi.
  - rules: override_dh_install stamps .version in the app JSON via jq+sponge from debian/changelog (do not edit the JSON version by hand).
  - install: places mtr-multiflexi under /usr/bin and app assets under /usr/lib/mtr/multiflexi and /usr/share/multiflexi/images.
  - postinst: runs multiflexi-json2app to register the app with MultiFlexi on install.
- CI/CD (debian/Jenkinsfile, debian/Jenkinsfile.release)
  - Builds for multiple Debian/Ubuntu distributions inside vendor images; uses dch to bump version, then debuild-pbuilder to produce artifacts.
  - Smoke-tests by creating a local apt repo (dpkg-scanpackages), adding it, apt-get install of the built package(s), then archives artifacts.
  - The release pipeline triggers a downstream MultiFlexi-publish job to publish to a remote repository.

Notes and gotchas
- Image tag consistency: Makefile builds vitexsoftware/multiflexi-mtr:latest, while the app descriptor lists ociimage: docker.io/vitexsoftware/mtr-multiflexi. Keep these aligned when publishing.
- Containerfile is named Containerfile (not Dockerfile); pass -f Containerfile when building outside make.
- Packaging stamps the app JSON version from debian/changelog; avoid manually changing the JSON version.
- Running mtr may require network capabilities (CAP_NET_RAW). In the container the default user is root; locally ensure mtr-tiny is installed with proper capabilities or run with sufficient privileges if you encounter permission errors.
- Prebuilt packages are available at https://repo.vitexsoftware.com; the installation commands are listed above.
