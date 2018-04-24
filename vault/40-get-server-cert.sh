#
# Retrieve Server Certificates for this machine
#
name=$1
source MYCA.RC
vault_url="${INTCA_ENDPOINT}"
vault_token="${token:-d8424ab0-7c38-7ac9-5c4c-5f9a52e21007}"
echo ${vault_token}

dest_dir=~/certs

#
# use the interface for the default route to compute the IP Addr
#
server_name=${name:-$(hostname)}
net_if=$(ip route | awk -F" " "/default via/ {print \$5}")
net_ip=$(ip addr show $net_if | awk -F" " "/inet / {print \$2}" |  cut -d\/ -f1 )
cat <<EOF >csr_server.json
{
  "common_name": "${server_name}",
  "alt_names": "localhost,${server_name},${server_name}.cloudra.local",
  "ip_sans": "127.0.0.1,${net_ip}",
  "use_csr_common_name": "true",
  "exclude_cn_from_sans": "true",
  "ttl": "8760h"
}
EOF
vi csr_server.json
#
# get the root CA Certificate, does not work as expected so juts copying it from the current folder
#
#curl -sk ${ROOTCA_ENDPOINT}/myca/ca/pem >ca.crt
cp -f ca.pem ca.crt

curl -sk --header "X-Vault-Token: $vault_token" --request POST --data @csr_server.json  ${vault_url}/issue/server >result.json
cat result.json | jq -r .data.ca_chain[]   >ca-chain.pem
cat result.json | jq -r .data.private_key  >${server_name}-key.pem
cat result.json | jq -r .data.certificate  >${server_name}-cert.pem

#
# the server cert must contains its own certificate plus the chain of CA certificates
#

cat ${server_name}-cert.pem ca-chain.pem >${server_name}-cachain.pem
tar --remove-files -cvf ${dest_dir}/bundle-server-${server_name}.tar \
    ca.crt \
    ${server_name}-cert.pem \
    ${server_name}-key.pem  \
    ${server_name}-cachain.pem

echo Created Bundle ${dest_dir}/bundle-server-${server_name}.tar
