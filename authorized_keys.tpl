{{ $keys := split (getenv "SSHD_AUTHORIZED_KEYS" "") ";" }}{{ range $keys }}{{.}}
{{ end }}