# Original credit: https://github.com/kylemanna/docker-openvpn
FROM alpine:latest

LABEL maintainer="Soeren Zorn <soeren.zorn@rwth-aachen.de>"

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Prevents refused client connection because of an expired CRL
ENV SERVER_ADDRESS=vpn.example.com \
    OVPN_MODE=tun \
    OVPN_PROTOCOL=udp \
    SERVER_INTERNAL_IP=10.8.0.0 \
    SERVER_INTERNAL_NETMASK=255.255.255.0 \
    OVPN_CLIENT_PORT=1194 \
    OVPN_KEEPALIVE="10 120" \
    OVPN_CIPHER=AES-256-CBC \
    OVPN_COMPRESS=0 \
    OVPN_TOPOLOGY=subnet \
    OVPN_VERB=3 \
    OVPN_MUTE=20 \
    OVPN_EXPLICIT_EXIT_NOTIFY=1 \
    CLIENT_TO_CLIENT=0 \
    PUSH_DNS="" \
    PUSH_REDIRECT_GATEWAY_DEF1=0 \
    PUSH_REDIRECT_GATEWAY_DEF1_BYPASS_DHCP=0 \
    SERVER_BRIDGE=0 \
    SERVER_BRIDGE_IP=192.168.8.1 \
    SERVER_BRIDGE_NETMASK=255.255.255.0 \
    SERVER_BRIDGE_DHCP_START=192.168.8.10 \
    SERVER_BRIDGE_DHCP_END=192.168.8.254 \
    SERVER_BRIDGE_BROADCAST=192.168.8.255 \
    OVPN_PRIVATE_KEY_FILE=/etc/ovpn/pki/private/myserverkey.key \
    OVPN_CA_KEY_FILE=/etc/ovpn/pki/ca.crt \
    OVPN_ISSUED_KEY_FILE=/etc/ovpn/pki/issued/myserverkey.crt \
    OVPN_DH_KEY_FILE=/etc/ovpn/pki/dh.pem \
    OVPN_TLS_AUTH=/etc/ovpn/pki/ta.key \
    EASYRSA_CRL_DAYS=3650


EXPOSE 1194/udp

ENTRYPOINT ["create_config"]
CMD ["ovpn_run"]

COPY ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
