FROM bitnami/minideb:buster

ARG godot_version=3.2.3
ARG godot_variant=stable
ENV DEBIAN_FRONTEND=noninteractive
ENV GODOT_VERSION=$godot_version
ENV GODOT_VARIANT=$godot_variant

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
  ca-certificates \
  git \
  git-lfs \
  curl \
  unzip \
  && curl https://downloads.tuxfamily.org/godotengine/$GODOT_VERSION/Godot_v$GODOT_VERSION-${GODOT_VARIANT}_linux_headless.64.zip -so engine.zip \
  && curl https://downloads.tuxfamily.org/godotengine/$GODOT_VERSION/Godot_v$GODOT_VERSION-${GODOT_VARIANT}_export_templates.tpz -so templates.zip \
  && unzip -qq engine.zip && rm engine.zip \
  && unzip -qq templates.zip && rm templates.zip \
  && mkdir -p /usr/local/share/godot/templates \
  && mv ./templates/linux_x11_64_release /usr/local/share/godot/templates \
  && mv ./templates/windows_64_release.exe /usr/local/share/godot/templates \
  && mv ./templates/osx.zip /usr/local/share/godot/templates \
  && rm -r ./templates \
  && mv ./Godot_v$GODOT_VERSION-${GODOT_VARIANT}_linux_headless.64 /usr/local/bin/godot \
  && apt-get -qq purge -y --auto-remove unzip curl \
  && apt-get -qq autoremove -y \
  && apt-get -qq autoclean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt \
  && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
