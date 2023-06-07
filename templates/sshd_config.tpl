AllowTcpForwarding {{ getenv "SSHD_ALLOW_TCP_FORWARDING" "no" }}
X11Forwarding no

Subsystem	sftp	internal-sftp

GatewayPorts {{ getenv "SSHD_GATEWAY_PORTS" "no" }}