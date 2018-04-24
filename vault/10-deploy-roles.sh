#
# Create the various roles needed when requesting certificates
#
#
#
source MYCA.RC

#
# server role
#
vault delete ${INTCA}/roles/server
vault write ${INTCA}/roles/server \
    max_ttl="${INTCA_TTL}" \
    key_bits=2048 \
    allow_any_name=true \
    server_flag=true \
    client_flag=true \
    ou="CloudRA Team" organization="HPE"


#
# see: https://www.vaultproject.io/intro/getting-started/acl.html
#
vault delete ${INTCA}/roles/client
vault write ${INTCA}/roles/client \
     max_ttl="8760h" ttl=8760h key_bits=2048 \
     allow_any_name=true \
     server_flag=false client_flag=true \
     enforce_hostnames=false \
     ou="CloudRA Team" \
     organization="HPE"

vault policy-write ${R_GET_CERT} - <<EOF
path "${INTCA}/issue/client" {
   policy = "write"
}
path "${INTCA}/issue/server" {
   policy = "write"
}
EOF
