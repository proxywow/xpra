ARG FEDORA_VERSION
FROM registry.fedoraproject.org/fedora-minimal:$FEDORA_VERSION
ARG XPRA_VERSION
EXPOSE 8080
ENV XPRA_UID 5001
RUN mkdir /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    adduser -u ${XPRA_UID} -m xpra && \
    touch /etc/dnf/dnf.conf && \
    mkdir /var/run/dbus && \
    mkdir -p /run/user/${XPRA_UID}/xpra/ && \
    chown -R xpra:xpra /run/user/${XPRA_UID} && \
    mkdir -p /var/lib/dbus && \
    rm -f /var/lib/rpm/.rpm.lock && \
    microdnf -y update && \
    rpm --import https://winswitch.org/gpg.asc && \
    cd /etc/yum.repos.d/ && \
    curl -O https://winswitch.org/downloads/Fedora/winswitch.repo && \
    microdnf -y update && \
    microdnf -y --nodocs install xpra-${XPRA_VERSION} xpra-html5-${XPRA_VERSION} x264-xpra ffmpeg-xpra python3-devel python3-uinput && \
    microdnf -y clean all && \
    rm -rf /var/cache/yum
COPY ./xpra.sh /usr/bin/xpra-nodaemon.sh
RUN chmod a+x /usr/bin/xpra-nodaemon.sh
USER xpra:xpra
RUN mkdir -p /home/xpra/.xpra
COPY ./xpra.conf /home/xpra/.xpra/xpra.conf
ENTRYPOINT ["/usr/bin/xpra-nodaemon.sh"]
