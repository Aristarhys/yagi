# Yet Another Godot Image

Image aimed to be used in Github actions for building Godot projects for windows and debian like linux distributions.

## Development

Clone this repo, change dockerfile, build and push.

`--squash` is [experimental feature](https://docs.docker.com/engine/reference/commandline/cli/#experimental-features) which is [not supported yet](https://github.com/docker/hub-feedback/issues/955) in dockerhub autobuilds.
```
docker build --squash --rm -t <username>/yagi:latest .
# after docker login
docker push <username>/yagi --all-tags
```
