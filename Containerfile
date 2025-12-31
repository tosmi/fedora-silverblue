FROM quay.io/fedora/fedora-silverblue:43

ENV VERSION=43

LABEL summary="Customized Fedora Silverblue containerized ostree image" \
      maintainer="Toni Schmidbauer <toni@stderr.at>"

COPY extra-packages /

# install cursor 2.0
RUN curl -Lo /tmp/cursor.rpm https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/2.2 && \
    dnf install -y /tmp/cursor.rpm && \
    rm -f /tmp/cursor.rpm

RUN (cd /etc/yum.repos.d; curl -LO https://repo.ivpn.net/stable/fedora/generic/ivpn.repo) && \
    (cd /etc/yum.repos.d; curl -LO https://pkgs.tailscale.com/stable/fedora/tailscale.repo) && \
    rpm -Uhv https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${VERSION}.noarch.rpm && \
    rpm -Uhv https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${VERSION}.noarch.rpm && \
    # force install of openh264, fedora-cisco-openh264 is enable per default
    rpm -e --nodeps noopenh264 && \
    dnf install -y $(< extra-packages) && \
    rm /extra-packages && \
    dnf install -y @cosmic-desktop-environment && \
    dnf clean all && \
    mkdir /nix && \
    ostree container commit
