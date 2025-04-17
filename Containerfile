FROM quay.io/fedora-ostree-desktops/silverblue:42

ENV VERSION=42

LABEL summary="Customized Fedora Silverblue containerized ostree image" \
      maintainer="Toni Schmidbauer <toni@stderr.at>"

COPY extra-packages /

RUN (cd /etc/yum.repos.d; curl -LO https://repo.ivpn.net/stable/fedora/generic/ivpn.repo) && \
    (cd /etc/yum.repos.d; curl -LO https://pkgs.tailscale.com/stable/fedora/tailscale.repo) && \
    rpm -Uhv https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${VERSION}.noarch.rpm && \
    rpm -Uhv https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${VERSION}.noarch.rpm && \
    #
    # fedora comes with noopen264 package installed
    # we would like to switch to fedora-openh264 but this requires
    # fedora-cisco-openh264 to be enabled
    # gnome desktop depends on freerdp depends on openh264
    # so we forcefully remove noopenh264 and install openh264
    # from fedora-cisco-openh264
    sed -ie 's/enabled=0/enabled=1/' /etc/yum.repos.d/fedora-cisco-openh264.repo && \
    rpm -e --nodeps noopenh264 && \
    rpm-ostree install -y $(< extra-packages) && \
    rm /extra-packages && \
    dnf install -y @cosmic-desktop-environment && \
    dnf clean all && \
    mkdir /nix && \
    ostree container commit
