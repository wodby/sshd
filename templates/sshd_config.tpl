AllowTcpForwarding {{ getenv "SSHD_ALLOW_TCP_FORWARDING" "yes" }}
X11Forwarding no

Subsystem	sftp	internal-sftp

GatewayPorts {{ getenv "SSHD_GATEWAY_PORTS" "yes" }}
PermitRootLogin {{ getenv "SSHD_PERMIT_ROOT_LOGIN" "yes" }}
