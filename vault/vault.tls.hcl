disable_mlock  = true
listener "tcp" {
  address = "0.0.0.0:8200",
  tls_cert_file = "/home/chris/vault/vault-cert.pem",
  tls_key_file = "/home/chris/vault/vault-key.pem"
}
backend "file" {
  path = "/home/chris/vault/secrets"
}

