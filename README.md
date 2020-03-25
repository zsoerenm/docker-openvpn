# OpenVPN for Docker

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.

This work is based on [kylemanna/docker-openvpn](https://github.com/kylemanna/docker-openvpn)

Differences from kylemanna/docker-openvpn:
* Support Bridge mode (see [Ethernet Bridging](https://openvpn.net/community-resources/ethernet-bridging/)) useful for LAN games
* Stateless configuration: Every configuration is set by environment variables
* The client profile specification `redirect-gateway def1` is not the default.
  If you'd like to enable it, you'll have to pass `PUSH_REDIRECT_GATEWAY_DEF1=1`.
  More on that [here](https://openvpn.net/community-resources/how-to/).
* The default topology is `subnet` instead of `net30`

#### Upstream Links

* Docker Registry @ [zsoerenm/openvpn](https://hub.docker.com/r/zsoerenm/openvpn/)
* GitHub @ [zsoerenm/docker-openvpn](https://github.com/zsoerenm/docker-openvpn)

## Quick Start

* Initialize the certifications. If you'd like to encrypt the private key with
  a password, you'll have to omit the `nopass` keyword in the following. The
  certificates will be saved in the docker volume `ovpn_pki_data`.

      docker run --rm -it -v ovpn_pki_data:/etc/ovpn zsoerenm/openvpn create_pki nopass

* Create certificates for each user. This can be done at any time. Replace
  `USERNAME` with the user name.

      docker run --rm -it -v ovpn_pki_data:/etc/ovpn zsoerenm/openvpn create_user_cert USERNAME nopass

* Run the OpenVPN server. There are multiple configuration options to configure
  the OpenVPN server. If you'd like to change the default value, you'll have to
  pass the environment variables with the different value to the docker command
  with the `-e` option, e.g. `-e SERVER_BRIDGE=1`. The default values will be
  shown below.

      docker run --rm -v ovpn_pki_data:/etc/ovpn -d -p 1194:1194/udp --cap-add=NET_ADMIN --privileged -e SERVER_ADDRESS=vpn.example.com zsoerenm/openvpn

* Retrieve the client configuration with embedded certificates. Replace
  `USERNAME` with the user name. Here you must set exactly the same environment
  variables as in the command to start the OpenVPN server.

      docker run --rm -v ovpn_pki_data:/etc/ovpn -e SERVER_ADDRESS=vpn.example.com zsoerenm/openvpn get_user_config USERNAME

## Next Steps

### More Reading

Miscellaneous write-ups for advanced configurations are available in the
[documentation](https://github.com/kylemanna/docker-openvpn/tree/master/docs)
of kylemanna/docker-openvpn. Some also apply here. If not I am happy to accept
pull requsts.

In addition, the default
[server.conf](https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/server.conf)
and
[client.conf](https://github.com/OpenVPN/openvpn/blob/master/sample/sample-config-files/client.conf)
of OpenVPN might be of interest.

### Docker Compose

```
version: '2'
services:
  openvpn:
    privileged: true
    cap_add:
     - NET_ADMIN
    image: zsoerenm/openvpn
    ports:
     - "1194:1194/udp"
    restart: unless-stopped
    environment:
     - SERVER_ADDRESS=vpn.example.com
    volumes:
     - ovpn_pki_data:/etc/ovpn
```

## Miscellaneous

* Revoke a user certification:

        docker run --rm -it -v ovpn_pki_data:/etc/ovpn zsoerenm/openvpn revoke_client USERNAME

* List all clients and their status

        docker run --rm -v ovpn_pki_data:/etc/ovpn zsoerenm/openvpn list_clients

## Debugging Tips

* Create an environment variable with the name DEBUG and value of 1 to enable debug output (using "docker -e").

        docker run --rm -v ovpn_pki_data:/etc/ovpn -d -p 1194:1194/udp --cap-add=NET_ADMIN --privileged -e SERVER_ADDRESS=vpn.example.com -e DEBUG=1 zsoerenm/openvpn

* See [kylemanna: Debugging Tips](https://github.com/kylemanna/docker-openvpn#debugging-tips)

## How Does It Work?

See [kylemanna: How Does It Work](https://github.com/kylemanna/docker-openvpn#how-does-it-work)

## Configuration Options

Here you'll find the configuration options and their default value:

```
SERVER_ADDRESS=vpn.example.com
OVPN_MODE=tun
OVPN_PROTOCOL=udp
SERVER_INTERNAL_IP=10.8.0.0
SERVER_INTERNAL_NETMASK=255.255.255.0
OVPN_CLIENT_PORT=1194
OVPN_KEEPALIVE="10 120"
OVPN_CIPHER=AES-256-CBC
OVPN_COMPRESS=0
OVPN_TOPOLOGY=subnet
OVPN_VERB=3
OVPN_MUTE=20
OVPN_EXPLICIT_EXIT_NOTIFY=1
CLIENT_TO_CLIENT=0
PUSH_DNS="" # Comma seperated list e.g. "208.67.222.222,208.67.220.220"
PUSH_REDIRECT_GATEWAY_DEF1=0
PUSH_REDIRECT_GATEWAY_DEF1_BYPASS_DHCP=0
SERVER_BRIDGE=0
SERVER_BRIDGE_IP=192.168.8.1
SERVER_BRIDGE_NETMASK=255.255.255.0
SERVER_BRIDGE_DHCP_START=192.168.8.10
SERVER_BRIDGE_DHCP_END=192.168.8.254
SERVER_BRIDGE_BROADCAST=192.168.8.255
OVPN_PRIVATE_KEY_FILE=/etc/ovpn/pki/private/myserverkey.key
OVPN_CA_KEY_FILE=/etc/ovpn/pki/ca.crt
OVPN_ISSUED_KEY_FILE=/etc/ovpn/pki/issued/myserverkey.crt
OVPN_DH_KEY_FILE=/etc/ovpn/pki/dh.pem
OVPN_TLS_AUTH=/etc/ovpn/pki/ta.key
EASYRSA_CRL_DAYS=3650
```

## License
MIT License
