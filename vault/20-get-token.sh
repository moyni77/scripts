#
# Generate token for creating new certificates
#
source MYCA.RC

tmpfile=$(mktemp)
vault token-create --format=json -policy="${R_GET_CERT}"  >${tmpfile}
client_token=$(cat ${tmpfile} | jq -r .auth.client_token)
client_accessor=$(cat ${tmpfile} | jq -r .auth.accessor)
echo export token=${client_token}
echo export accessor=${client_accessor}
