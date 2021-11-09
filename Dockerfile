FROM debian:bullseye
LABEL maintainer="Matthew DePorter"

ARG DEBIAN_FRONTEND=noninteractive

ENV pip_packages "ansible cryptography"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo systemd systemd-sysv \
       build-essential wget libffi-dev libssl-dev \
       python3-pip python3-dev python3-setuptools python3-wheel python3-apt \
       iproute2 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Upgrade pip to latest version.
RUN pip3 install --upgrade pip

# Install Ansible via pip.
RUN pip3 install $pip_packages

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Configure Proxmox VE Repositories
RUN apt-get update && apt-get install wget -y && \
    echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list && \
    wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg && \
    chmod +r /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

# OPTIONAL: Simulate Enterprise repositories
# RUN echo -e '# deb https://enterprise.proxmox.com/debian/pve bullseye pve-enterprise' > /etc/apt/sources.list.d/pve-enterprise.list

# Install Proxmox VE
RUN apt-get update && apt-get full-upgrade -y

# RUN apt-get install proxmox-ve -y || true
RUN apt-get install alsa-topology-conf alsa-ucm-conf apparmor attr bridge-utils bsd-mailx busybox ceph-common ceph-fuse cifs-utils corosync cpio criu cstream curl dbus dbus-user-session dconf-gsettings-backend dconf-service dirmngr dmeventd dosfstools dtach ebtables exim4-base exim4-config exim4-daemon-light faketime file fontconfig fontconfig-config fonts-dejavu-core fonts-font-awesome fonts-glyphicons-halflings fuse gdisk genisoimage gettext-base glib-networking glib-networking-common glib-networking-services glusterfs-client glusterfs-common gnupg gnupg-l10n gnupg-utils gnutls-bin gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf gpgsm groff-base grub-common grub-pc grub-pc-bin grub2-common gsettings-desktop-schemas gstreamer1.0-libav gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-x hdparm i965-va-driver ibverbs-providers idn intel-media-va-driver ipset iptables iso-codes keyutils klibc-utils kmod libaa1 libaacs0 libaio1 libanyevent-http-perl libanyevent-perl libaom0 libappconfig-perl libapt-pkg-perl libarchive13 libasound2 libasound2-data libass9 libassuan0 libasync-interrupt-perl libasyncns0 libauthen-pam-perl libauthen-sasl-perl libavahi-client3 libavahi-common-data libavahi-common3 libavc1394-0 libavcodec58 libavfilter7 libavformat58 libavutil56 libbabeltrace1 libbdplus0 libblas3 libbluray2 libboost-context1.74.0 libboost-coroutine1.74.0 libboost-iostreams1.74.0 libboost-program-options1.74.0 libboost-thread1.74.0 libbrotli1 libbs2b0 libbytes-random-secure-perl libcaca0 libcairo-gobject2 libcairo2 libcbor0 libcdparanoia0 libcephfs2 libcfg7 libchromaprint1 libclone-perl libcmap4 libcodec2-0.9 libcommon-sense-perl libconvert-asn1-perl libcorosync-common4 libcpg4 libcrypt-openssl-bignum-perl libcrypt-openssl-random-perl libcrypt-openssl-rsa-perl libcrypt-random-seed-perl libcrypt-ssleay-perl libcups2 libcurl3-gnutls libcurl4 libdata-dump-perl libdatrie1 libdav1d4 libdbi1 libdbus-1-3 libdconf1 libdeflate0 libdevel-cycle-perl libdevmapper-event1.02.1 libdigest-bubblebabble-perl libdigest-hmac-perl libdrm-amdgpu1 libdrm-common libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libdrm2 libdv4 libdw1 libedit2 libefiboot1 libefivar1 libencode-locale-perl libev-perl libevent-2.1-7 libfaketime libfdt1 libfftw3-double3 libfido2-1 libfile-chdir-perl libfile-listing-perl libfile-readbackwards-perl libfilesys-df-perl libflac8 libflite1 libfont-afm-perl libfontconfig1 libfreetype6 libfribidi0 libfuse2 libfuse3-3 libgdk-pixbuf-2.0-0 libgdk-pixbuf2.0-bin libgdk-pixbuf2.0-common libgfapi0 libgfchangelog0 libgfortran5 libgfrpc0 libgfxdr0 libgl1 libgl1-mesa-dri libglapi-mesa libglib2.0-0 libglib2.0-data libglusterd0 libglusterfs0 libglvnd0 libglx-mesa0 libglx0 libgme0 libgnutls-dane0 libgnutlsxx28 libgoogle-perftools4 libgpgme11 libgpm2 libgraphite2-3 libgsm1 libgssapi-perl libgstreamer-plugins-base1.0-0 libgstreamer1.0-0 libguard-perl libgudev-1.0-0 libharfbuzz0b libhtml-form-perl libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libibverbs1 libicu67 libidn11 libiec61883-0 libigdgmm11 libinih1 libio-html-perl libio-multiplex-perl libio-socket-ssl-perl libio-stringy-perl libip6tc2 libipset13 libiscsi7 libjack-jackd2-0 libjansson4 libjbig0 libjemalloc2 libjpeg62-turbo libjs-bootstrap libjs-extjs libjson-glib-1.0-0 libjson-glib-1.0-common libjson-perl libjson-xs-perl libklibc libknet1 libksba8 liblapack3 libldap-2.4-2 libldap-common libldb2 libleveldb1d liblilv-0-0 liblinux-inotify2-perl libllvm11 liblmdb0 liblockfile-bin liblockfile1 liblvm2cmd2.03 liblwp-mediatypes-perl liblwp-protocol-https-perl liblzo2-2 libmagic-mgc libmagic1 libmailtools-perl libmath-random-isaac-perl libmath-random-isaac-xs-perl libmfx1 libmime-base32-perl libmp3lame0 libmpg123-0 libmysofa1 libncurses6 libnet-dbus-perl libnet-dns-perl libnet-dns-sec-perl libnet-http-perl libnet-ip-perl libnet-ldap-perl libnet-libidn-perl libnet-smtp-ssl-perl libnet-ssleay-perl libnet1 libnetaddr-ip-perl libnetfilter-conntrack3 libnetfilter-log1 libnfnetlink0 libnfsidmap2 libnftables1 libnftnl11 libnghttp2-14 libnl-3-200 libnl-route-3-200 libnorm1 libnozzle1 libnpth0 libnspr4 libnss3 libnuma1 libnvpair3linux liboath0 libogg0 libopenjp2-7 libopenmpt0 libopts25 libopus0 liborc-0.4-0 libpam-systemd libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpci3 libpciaccess0 libperl4-corelibs-perl libpgm-5.3-0 libpixman-1-0 libpng16-16 libpocketsphinx3 libpopt0 libpostproc55 libprocps8 libprotobuf-c1 libprotobuf23 libproxmox-acme-perl libproxmox-acme-plugins libproxmox-backup-qemu0 libproxy1v5 libpulse0 libpve-access-control libpve-apiclient-perl libpve-cluster-api-perl libpve-cluster-perl libpve-common-perl libpve-guest-common-perl libpve-http-server-perl libpve-rs-perl libpve-storage-perl libpve-u2f-server-perl libqb100 libqrencode4 libquorum5 librabbitmq4 librados2 librados2-perl libradosstriper1 libraw1394-11 librbd1 librdmacm1 librrd8 librrds-perl librsvg2-2 librsvg2-common librtmp1 librubberband2 libsamplerate0 libsasl2-2 libsasl2-modules libsasl2-modules-db libsdl1.2debian libsensors-config libsensors5 libserd-0-0 libshine3 libshout3 libslang2 libsmbclient libsnappy1v5 libsndfile1 libsocket6-perl libsodium23 libsord-0-0 libsoup2.4-1 libsoxr0 libspeex1 libsphinxbase3 libspice-server1 libsratom-0-0 libsrt1.4-gnutls libssh-gcrypt-4 libssh2-1 libstatgrab10 libstring-shellquote-perl libswresample3 libswscale5 libtag1v5 libtag1v5-vanilla libtalloc2 libtcmalloc-minimal4 libtdb1 libtemplate-perl libterm-readline-gnu-perl libtevent0 libtext-iconv-perl libthai-data libthai0 libtheora0 libtie-ixhash-perl libtiff5 libtimedate-perl libtpms0 libtry-tiny-perl libtwolame0 libtypes-serialiser-perl libu2f-server0 libuchardet0 libudfread0 libunbound8 libunwind8 liburcu6 liburi-perl liburing1 libusb-1.0-0 libusbredirparser1 libuuid-perl libuutil3linux libv4l-0 libv4lconvert0 libva-drm2 libva-x11-2 libva2 libvdpau-va-gl1 libvdpau1 libvidstab1.1 libvisual-0.4-0 libvorbis0a libvorbisenc2 libvorbisfile3 libvotequorum8 libvpx6 libvulkan1 libwavpack1 libwayland-client0 libwbclient0 libwebp6 libwebpmux3 libwrap0 libwww-perl libwww-robotrules-perl libx11-6 libx11-data libx11-xcb1 libx264-160 libx265-192 libxau6 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-randr0 libxcb-render0 libxcb-shm0 libxcb-sync1 libxcb-xfixes0 libxcb1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxml-libxml-perl libxml-namespacesupport-perl libxml-parser-perl libxml-sax-base-perl libxml-sax-expat-perl libxml-sax-perl libxml-twig-perl libxml-xpathengine-perl libxml2 libxmuu1 libxrender1 libxshmfence1 libxslt1.1 libxv1 libxvidcore4 libxxf86vm1 libyaml-0-2 libyaml-libyaml-perl libz3-4 libzfs4linux libzmq5 libzpool4linux libzvbi-common libzvbi0 linux-base logrotate lvm2 lxc-pve lxcfs lzop mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers ncurses-term netbase nfs-common nftables novnc-pve numactl ocl-icd-libopencl1 openssh-client openssh-server openssh-sftp-server os-prober pci.ids pciutils perl-openssl-defaults pigz pinentry-curses pocketsphinx-en-us powermgmt-base procps proxmox-archive-keyring proxmox-backup-client proxmox-backup-file-restore proxmox-backup-restore-image proxmox-mini-journalreader proxmox-widget-toolkit psmisc pve-cluster pve-container pve-docs pve-edk2-firmware pve-firewall pve-firmware pve-ha-manager pve-i18n pve-lxc-syscalld pve-qemu-kvm pve-xtermjs python3-ceph-argparse python3-cephfs python3-certifi python3-cffi-backend python3-chardet python3-cryptography python3-gpg python3-idna python3-jwt python3-ldb python3-prettytable python3-protobuf python3-rados python3-rbd python3-requests python3-samba python3-six python3-talloc python3-tdb python3-urllib3 qemu-server qrencode rpcbind rrdcached rsync runit-helper samba-common samba-common-bin samba-dsdb-modules samba-libs sensible-utils shared-mime-info smartmontools smbclient socat spiceterm sqlite3 swtpm swtpm-libs swtpm-tools thin-provisioning-tools ucf udev uidmap va-driver-all vdpau-driver-all vncterm xauth xdg-user-dirs xfsprogs xsltproc zfs-zed zfsutils-linux zstd -y

# Make sure systemd doesn't start agettys on tty[1-6].
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
