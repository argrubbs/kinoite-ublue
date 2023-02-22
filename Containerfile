# Multi-stage build
ARG FEDORA_MAJOR_VERSION=37

## Build ublue-os-base
FROM quay.io/fedora-ostree-desktops/kinoite-nightly:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

RUN wget https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm
RUN wget https://packages.microsoft.com/yumrepos/vscode/code-1.75.1-1675893486.el7.x86_64.rpm

RUN rpm-ostree install distrobox just tailscale asusctl supergfxctl gstreamer1-plugin-openh264 mozilla-openh264 code-1.75.1-1675893486.el7.x86_64.rpm && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl enable tailscaled.service && \
    systemctl enable supergfxd.service && \
    ostree container commit