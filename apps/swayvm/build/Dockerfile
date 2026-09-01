# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE

# hadolint ignore=DL3006
FROM ${BASE_APP_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive
ARG REQUIRED_PACKAGES=" \
    libpci3 \
    libavcodec-extra \
    ubuntu-restricted-extras \
"

# Install waterfox from their OpenSUSE repository
RUN <<_INSTALL_PACKAGES
set -e
apt-get update
apt-get install -y --no-install-recommends wget ca-certificates
apt-get update
apt-get install -y --no-install-recommends $REQUIRED_PACKAGES

# tools I want to use
apt-get install -y neovim git openssh-client fonts-noto-color-emoji

# chinese input
apt-get install -y fcitx5 fcitx5-rime fcitx5-chinese-addons librime-data librime-data-luna-pinyin fcitx5-frontend-gtk3 fcitx5-frontend-gtk4 fcitx5-config-qt fcitx5-frontend-qt5

#im-config -n fcitx5

# waterfox install
curl -fsSL https://download.opensuse.org/repositories/isv:/BrowserWorks/xUbuntu_24.04/Release.key \
  | gpg --dearmor | tee /usr/share/keyrings/waterfox.gpg > /dev/null
echo 'deb [signed-by=/usr/share/keyrings/waterfox.gpg] https://download.opensuse.org/repositories/isv:/BrowserWorks/xUbuntu_24.04/ /' \
  | tee /etc/apt/sources.list.d/waterfox.list
apt update && apt install waterfox

# tchmin dependencies
apt-get install -y libmpv2 libgtk-3-0 libwebkit2gtk-4.1-0 libegl1 librsvg2-2 libayatana-appindicator3-1 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libfuse2t64

# tofi launch menu
# build-time dependencies (headers + build tools)
apt-get install -y --no-install-recommends \
    libfreetype-dev libcairo2-dev libpango1.0-dev libwayland-dev libxkbcommon-dev \
    meson scdoc wayland-protocols build-essential

# fetch and build
git clone --depth 1 https://github.com/philj56/tofi.git /tmp/tofi
cd /tmp/tofi
meson setup build --prefix=/usr --buildtype=release
ninja -C build install
# clean-up: drop build tools/headers, keep only runtime libs pulled in as their deps
apt-get purge -y meson scdoc wayland-protocols build-essential \
    libfreetype-dev libcairo2-dev libpango1.0-dev libwayland-dev libxkbcommon-dev git
apt-get autoremove -y
rm -rf /var/lib/apt/lists/* /tmp/tofi
_INSTALL_PACKAGES

# 
# Replace launch scripts
#COPY --chmod=777 scripts/launch-comp.sh scripts/startup.sh /opt/gow/
COPY --chmod=777 scripts/startup.sh /opt/gow/
#COPY --chmod=777 scripts/startdbus.sh /opt/gow/startdbus

# 
# Fix locals
#COPY scripts/locale /etc/default/locale

# 
# Allow anyone to start dbus without password
RUN echo "\nALL ALL=NOPASSWD: /opt/gow/startdbus" >> /etc/sudoers

ENV XDG_RUNTIME_DIR=/tmp/.X11-unix

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
