#
# Retrieve TLS client Certificates for this machine
#
source MYCA.RC

vault_url="${INTCA_ENDPOINT}"
vault_token="${token:-d8424ab0-7c38-7ac9-5c4c-5f9a52e21007}"

echo ${vault_token}

ca_crt="$(mktemp)".ca.pem
result_json="$(mktemp)".result.json
csr_json="$(mktemp)".csr.json
ca_chain=$(mktemp).chain.pem
dest_dir=~/certs

#
# Get the Root CA Certificate
#

client_name=${1:-$(whoami)}
echo Generating TLS certs for $client_name
cat <<EOF > "${csr_json}"
{
  "common_name": "client certificate for ${client_name}",
  "exclude_cn_from_sans": "true",
  "ttl": "8760h"
}
EOF

#
# get the root CA certificate
#
#curl -k ${vault_url}/myca/ca/pem >ca.crt

curl -sk --cacert ${ca_crt} --header "X-Vault-Token: $vault_token" --request POST --data @${csr_json} ${vault_url}/issue/client > ${result_json}
cat ${result_json} | jq -r .data.ca_chain[]   >${client_name}-cachain.pem
cat ${result_json} | jq -r .data.private_key  >${client_name}-key.pem
cat ${result_json} | jq -r .data.certificate  >${client_name}-cert.pem

tar --remove-files -cvf ${dest_dir}/bundle-${client_name}.tar  \
    ${client_name}-key.pem \
    ${client_name}-cert.pem \
    ${client_name}-cachain.pem \
    ${result_json} 


echo Bundle in ${dest_dir}/bundle-${client_name}.tar
