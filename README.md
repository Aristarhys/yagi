# Yet Another Godot Image

Image aimed to be used in Github actions for building [Godot](https://godotengine.org/) projects.

## Example action

```yaml
name: Build published release
on:
  release:
    types: [published]
jobs:
  Release:
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
        uses: actions/checkout@v2
        with:
          lfs: true

      - name: Build release
        working-directory: $GITHUB_WORKSPACE
        env:
          BUILD_PLATFORM: ${{ matrix.platform }}
          BUILD_EXT: ${{ matrix.out_ext }}
        run: |
          mkdir -p /releases
          godot --export $BUILD_PLATFORM /releases/$BUILD_PLATFORM.$BUILD_EXT

      - name: Upload release to action
        uses: actions/upload-artifact@v2
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
