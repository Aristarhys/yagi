#!/bin/sh

mkdir -p $HOME/.local/share/godot/templates/
ln -s /usr/local/share/godot/templates/ $HOME/.local/share/godot/templates/$GODOT_VERSION.${GODOT_VARIANT}
exec "$@"
