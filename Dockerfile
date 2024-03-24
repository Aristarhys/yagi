FROM bitnami/minideb:latest

# GODOT_VERSION=3.5.3
# GODOT_ENGINE_POSTFIX=_headless.64
# GODOT_LINUX_TEMPLATE=linux_x11_64
# GODOT_WINDOWS_TEMPLATE=windows_64_release.exe
# GODOT_MACOS_TEMPLATE=osx.zip

ARG GODOT_VERSION=4.2.1
ARG GODOT_ENGINE_POSTFIX=.x86_64
ARG GODOT_ENGINE_TEMPLATE=linux_release.x86_64
ARG GODOT_WINDOWS_TEMPLATE=windows_release_x86_64.exe
ARG GODOT_MACOS_TEMPLATE=macos.zip

ENV GODOT_VERSION=$GODOT_VERSION
ENV GODOT_ENGINE_POSTFIX=$GODOT_ENGINE_POSTFIX
ENV GODOT_LINUX_TEMPLATE=$GODOT_ENGINE_TEMPLATE
ENV GODOT_WINDOWS_TEMPLATE=$GODOT_WINDOWS_TEMPLATE
ENV GODOT_MACOS_TEMPLATE=$GODOT_MACOS_TEMPLATE

RUN install_packages curl unzip git git-lfs ca-certificates \
&& curl https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux${GODOT_ENGINE_POSTFIX}.zip -so /tmp/godot.zip \
&& unzip -qq -d /tmp /tmp/godot.zip \
&& curl https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz -so /tmp/templates.zip \
&& unzip -qq -d /tmp/ /tmp/templates.zip \
&& mkdir -p /usr/local/share/godot/templates \
&& mv /tmp/Godot_v${GODOT_VERSION}-stable_linux${GODOT_ENGINE_POSTFIX} /usr/local/bin/godot \
&& mv -t /usr/local/share/godot/templates /tmp/templates/${GODOT_LINUX_TEMPLATE} /tmp/templates/${GODOT_WINDOWS_TEMPLATE} /tmp/templates/${GODOT_MACOS_TEMPLATE} \
&& rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
