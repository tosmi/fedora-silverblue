FROM quay.io/fedora-ostree-desktops/silverblue:39

# this stopped to be updated
# quay.io/fedora/fedora-silverblue:39

ENV VERSION=39

LABEL summary="Customized Fedora Silverblue containerized ostree image" \
      maintainer="Toni Schmidbauer <toni@stderr.at>"

COPY extra-packages /

RUN rpm -Uhv https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${VERSION}.noarch.rpm && \
    rpm -Uhv https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${VERSION}.noarch.rpm && \
    (cd /etc/yum.repos.d; curl -LO https://repo.ivpn.net/stable/fedora/generic/ivpn.repo) && \
    (cd /etc/yum.repos.d; curl -LO https://pkgs.tailscale.com/stable/fedora/${VERSION}/tailscale.repo) && \
    rpm-ostree install -y $(< extra-packages) && \
    rm /var/lib/unbound/root.key && \
    rm /extra-packages && \
    ostree container commit
