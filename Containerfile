# Multi-stage build
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

## Build ublue-os-base
FROM quay.io/fedora-ostree-desktops/kinoite-nightly:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

RUN wget wget https://update.code.visualstudio.com/latest/linux-rpm-x64/stable -O code.rpm

RUN rpm-ostree install distrobox just tailscale asusctl supergfxctl gstreamer1-plugin-openh264 mozilla-openh264 code.rpm && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl enable tailscaled.service && \
    systemctl enable supergfxd.service && \
    ostree container commit
