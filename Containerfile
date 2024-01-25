FROM quay.io/fedora/fedora-silverblue:39

ENV VERSION=39

LABEL summary="Customized Fedora Silverblue containerized ostree image" \
      maintainer="Toni Schmidbauer <toni@stderr.at>"

RUN rpm -Uhv https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${VERSION}.noarch.rpm && \
    rpm -Uhv https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${VERSION}.noarch.rpm 

# We need to create /var/opt/ivpn to work around a bug in the ivpn package
# otherwise installing the package will fail
RUN  mkdir -p /var/opt/ivpn/ &&  \
     rpm -ihv https://repo.ivpn.net/stable/pool/ivpn-3.13.4-1.x86_64.rpm && \
     rpm -ihv https://repo.ivpn.net/stable/pool/ivpn-ui-3.13.4-1.x86_64.rpm

COPY extra-packages /
RUN rpm-ostree install -y $(< extra-packages) && \
    rm /var/lib/unbound/root.key && \
    rm /extra-packages && \
    ostree container commit 
