FROM alpine:3 AS util

FROM util AS download

ARG godot_version=3.2.3
ARG godot_variant=stable
ENV GODOT_VERSION=$godot_version
ENV GODOT_VARIANT=$godot_variant

RUN apk --no-cache add curl
WORKDIR /downloads
RUN curl https://downloads.tuxfamily.org/godotengine/$GODOT_VERSION/Godot_v$GODOT_VERSION-${GODOT_VARIANT}_linux_headless.64.zip -so engine.zip \
    && curl https://downloads.tuxfamily.org/godotengine/$GODOT_VERSION/Godot_v$GODOT_VERSION-${GODOT_VARIANT}_export_templates.tpz -so templates.zip

FROM util AS unzip

RUN apk --no-cache add unzip
WORKDIR /unzipped
COPY --from=download /downloads .
RUN unzip -qq engine.zip && rm engine.zip \
    && unzip -qq templates.zip && rm templates.zip

FROM bitnami/minideb:buster

ARG godot_version=3.2.3
ARG godot_variant=stable
ENV DEBIAN_FRONTEND=noninteractive
ENV GODOT_VERSION=$godot_version
ENV GODOT_VARIANT=$godot_variant

COPY --from=unzip /unzipped /tmp

RUN install_packages git git-lfs ca-certificates \
  && mkdir -p /usr/local/share/godot/templates \
  && mv /tmp/templates/linux_x11_64_release /usr/local/share/godot/templates \
  && mv /tmp/templates/windows_64_release.exe /usr/local/share/godot/templates \
  && mv /tmp/templates/osx.zip /usr/local/share/godot/templates \
  && mv /tmp/Godot_v$GODOT_VERSION-${GODOT_VARIANT}_linux_headless.64 /usr/local/bin/godot \
  && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
