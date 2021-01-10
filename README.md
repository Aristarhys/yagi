# Yet Another Godot Image

Image aimed to be used in Github actions for building Godot projects for windows and debian like linux distributions.

## Development

Clone this repo, change dockerfile, build and push (`--squash` is [experimental feature](https://docs.docker.com/engine/reference/commandline/cli/#experimental-features))
```
docker build --squash --rm -t <username>/yagi:latest -t <username>/yagi:3.2.3 .
# after docker login
docker push <username>/image --all-tags
```
