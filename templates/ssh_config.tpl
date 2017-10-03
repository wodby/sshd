Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
  ServerAliveInterval={{ getenv "SSH_SERVER_ALIVE_INTERVAL" "5" }}
  ServerAliveCountMax={{ getenv "SSH_SERVER_ALIVE_COUNT_MAX" "3" }}
