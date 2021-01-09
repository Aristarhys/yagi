FROM bitnami/minideb:bullseye

ARG godot_version=3.4
ENV GODOT_VERSION=$godot_version

RUN install_packages curl unzip git git-lfs ca-certificates \
  && curl https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip -so /tmp/godot.zip \
  && unzip -qq -d /tmp /tmp/godot.zip \
  && curl https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -so /tmp/templates.zip \
  && unzip -qq -d /tmp/ /tmp/templates.zip \
  && mkdir -p /usr/local/share/godot/templates \
  && mv -t /usr/local/share/godot/templates /tmp/templates/linux_x11_64_release /tmp/templates/windows_64_release.exe /tmp/templates/osx.zip \
  && mv /tmp/Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot \
  && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
