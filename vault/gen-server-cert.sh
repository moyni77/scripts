#
# Retrieve Server Certificates for this machine
#
vault_url="https://10.7.0.4:8200/v1/myca_ops"
vault_token="d8424ab0-7c38-7ac9-5c4c-5f9a52e21007"

#
# Get the Root CA Certificate
#
cat <<EOF >ca.crt
-----BEGIN CERTIFICATE-----
MIIFODCCAyCgAwIBAgIUHo6pa7575VrdV+GppMLwQhZMEvowDQYJKoZIhvcNAQEL
BQAwIjEgMB4GA1UEAxMXQ2hyaXN0b3BoZSBMZWh5IFJvb3QgQ0EwHhcNMTcwNjI0
MjAyMDI3WhcNMjcwNjIyMjAyMDU3WjAiMSAwHgYDVQQDExdDaHJpc3RvcGhlIExl
aHkgUm9vdCBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAM9fYSOS
a/i4KIsKiQw1vt3sU2+nGZw6rsuhOPHSPQP4iCe1UgJT7bLAMUBE1dvVTjBA1ATy
Saq+LYOVi68snLTxlCrPuOpMy0Q8NCDMtjKi7nUuAtoXSGriwQF8QqjtLsWnTFPn
cTh2IgZ+R8Hk+fQLz3yWpxnI9iFNYhp5oPd9tVKJoIxEaL6Bu5yXdLKkbHnvTZPK
ddqFdXnDokR1/ZHdCG1nh2OTuJlblPZGiNcPTL6TSkwurriltKw0yodL5zGuph1H
fX2U13oS1SWvQ/123WAFm0GpLwU4uSC/Bz+xdHoKbVcPrx+eJ5THTc7pt9c0KuLx
E7FzelxRwBh5zROUVWs1l2TXKyNba53ZGjpBrleK+zIWZ9fjY4TzcvgSewGNEx7K
TM8jRKO30wSgCmyNn+1S4H2bvQGfkZ7qY1oS9/1ROoAl6LlTZ42bv3HROkxofV8p
YNH6QvSTKpLtUfs0w0ahj2R2DGI1UGUEPiP8wqaw1a+4NS7Jyosf8A28NeX3lQZ9
Dr67M8TFrL/hXX7n0MPW4S1tBeAx7E88hGql9T8gbg8g0jZpL08FDnkv/Y9aYKLK
QfU0gH3MPG7eqdpkPcH8ot3T//ce7LjbcFS1aBov5xIqj5iBom354hJsZOS1LQFi
b0ccqZrsOOuzQd3vj+6ADoW2K4Icl7eOgzJTAgMBAAGjZjBkMA4GA1UdDwEB/wQE
AwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQ/xF4O/W8Virq5UnYzh31c
fPQA/DAiBgNVHREEGzAZghdDaHJpc3RvcGhlIExlaHkgUm9vdCBDQTANBgkqhkiG
9w0BAQsFAAOCAgEAot15Lxb6nPQHmMQcOJSr9NpT9a4JY+s1/Te8tvZEAjRyusjp
50jvIH41HBEx6XO6bgdI56mL9rInedvaW/R5n5hncoE9wfxiELJt44ZSDvHxhd4v
T6i1eLykt4wLDjfpEdm+2ibiohVL6MWmRi9eFYxW6FsWiYdcJtzrmrnmzrV38O6n
ZKpQsHJz+rR9BlVvrM16NdWtzA0ySso/CLbIqrTvfrm5Xuyu8KdnzGIVgIMiz9mi
xKsT2gg395hG+Np3Me1gzR2VS+to8Rg0Ql0XEtaOQI4Orkxtt8mrRjAf/P/+4BOd
2pyHqyqkJo9yZ/Mnz6Nv1HkqdfLvjLHIoxHLG2rdKg46tENcL0xsUy8E1v2yBP6h
sPEVYseegYJKAxDSuXUc9x0gaSwFKUEXoKqLOHHl5W3YsyQd8qFgGJDOKbDPbfFJ
qiumxNglaxaqYgv1jvedFDIby8CDvCLQeedYKVAbvsN5YUf6ijDEjijO0jbJmyVj
7LjmiG/zD0pWB65i/o0leSkoY0z4BnLtKAFPOCGqrFHKvEdPAuye5EDUMK5V8e+z
NmrbuMFHAsywZeRle1zUNnyWQwyWpWoEZ+EJIxM0DVHS9yN+VfwxQxjpaYQnnMLh
iednr5tVFap5rgCJxi+wC5sHlzqS4o476GVpfS8E/ND/fzy5Tj86hD1LZvs=
-----END CERTIFICATE-----
EOF

#
# with use the interface for the default route to compute the IP Addr
#
server_name=$(hostname)
net_if=$(ip route | awk -F" " "/default via/ {print \$5}")
net_ip=$(ip addr show $net_if | awk -F" " "/inet / {print \$2}" |  cut -d\/ -f1 )
cat <<EOF >csr_server.json
{
  "common_name": "${server_name}",
  "alt_names": "localhost,${server_name},${server_name}.cloudra.local",
  "ip_sans": "127.0.0.1,${net_ip}",
  "use_csr_common_name": "true",
  "exclude_cn_from_sans": "true",
  "ttl": "8760"
}
EOF

#
# get the root CA certificate
#
#curl -k ${vault_url}/myca/ca/pem >ca.crt

curl --cacert ca.crt --header "X-Vault-Token: $vault_token" --request POST --data @csr_server.json  ${vault_url}/issue/server >result.json
curl -sk --header "X-Vault-Token: $vault_token" --request POST --data @csr_server.json  ${vault_url}/issue/server >result.json
cat result.json | jq -r .data.ca_chain[0]  >ca-chain.pem
cat result.json | jq -r .data.private_key  >${server_name}-key.pem
cat result.json | jq -r .data.certificate  >${server_name}-cert.pem
#
# the server cert must contains its own certificate plus the chain of CA certificates
#
cat ${server_name}-cert.pem ca-chain.pem >${server_name}-certchain.pem

cat ${server_name}-key.pem  | sudo tee /etc/docker/key.pem >/dev/null
cat ${server_name}-certchain.pem | sudo tee /etc/docker/cert.pem >/dev/null
cat ca.crt | sudo tee /usr/local/share/ca-certificates/ca.crt >/dev/null


