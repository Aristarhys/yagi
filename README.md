# Yet Another Godot Image

Image aimed to be used in Github actions for building [Godot](https://godotengine.org/) projects.

## Developing

```bash
docker build -t aristarhys/yagi:latest -t aristarhys/yagi:4.2.1 --squash=true .
docker push --all-tags aristarhys/yagi
```

## Example action

```yaml
name: Build published release
on:
  release:
    types: [published]
jobs:
  release:
    name: "Publish platform release"
    runs-on: ubuntu-latest
    container:
      image: aristarhys/yagi:latest
    strategy:
      max-parallel: 3
      matrix:
        platform: ["linux", "windows", "mac"]
        include:
          - platform: "linux"
            out_ext: "x86_64"
          - platform: "windows"
            out_ext: "exe"
          - platform: "mac"
            out_ext: "zip"
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          lfs: true
          fetch-depth: 0

      - name: Build release
        working-directory: $GITHUB_WORKSPACE
        env:
          BUILD_PLATFORM: ${{ matrix.platform }}
          BUILD_EXT: ${{ matrix.out_ext }}
        run: |
          mkdir -p /releases
          godot --export $BUILD_PLATFORM /releases/$BUILD_PLATFORM.$BUILD_EXT

      - name: Upload release to assets
        uses: actions/upload-artifact@v4
        with:
          name: ${{ matrix.platform }}-release
          path: /releases/${{ matrix.platform }}.${{ matrix.out_ext }}

      - name: Upload release to published tag
        uses: svenstaro/upload-release-action@v2
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          file: /releases/${{ matrix.platform }}.${{ matrix.out_ext }}
          asset_name: ${{ matrix.platform }}-$tag.${{ matrix.out_ext }}
          tag: ${{ github.ref }}
```

## Example static check action

Using [gdscript toolkit](https://github.com/Scony/godot-gdscript-toolkit)

```yaml
name: Check pushed code
on:
  push:
    branches:
      - main
    release:
      types:
        - created
  pull_request:
    branches:
      - main
jobs:
  check:
    runs-on: ubuntu-latest
    name: "Check pushed code"
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          lfs: true
          fetch-depth: 0
      - name: "Install gd script toolkit"
        uses: Scony/godot-gdscript-toolkit@master
      - name: "Check lint"
        run: gdlint .
      - name: "Check formatting"
        run: gdformat --check .
```
