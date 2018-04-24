#
# Verifies that the specified repo exists
#
script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

repo=$1
if [ "$repo" == "" ]
then
 echo "$0 repo"
 echo "  verifies that the specified repo exists"
 exit 1
else
  echo Verifying repo admin/$repo at $DTR_IP
fi

token=$(curl -s -k -X POST "https://$UCP_IP/id/login" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"username\": \"${UCP_ADMIN}\",\"password\": \"${UCP_PASSWORD}\"}" | jq -r .sessionToken)


identitytoken=$(curl -s -X POST "https://clh-ucp.cloudra.local/auth" -H  "accept: application/json" -H  "Authorization: Bearer $token" -H  "content-type: application/json" -d "{  \"password\": \"Just4m3hp\",  \"serveraddress\": \"https://clh-dtr.cloudra.local/v0/\",  \"username\": \"Admin\"}" | jq -r .IdentityToken)


curl -i -s -k -X GET "https://${DTR_IP}/api/v0/repositories/admin/$repo" \
   --user "$UCP_ADMIN:$UCP_PASSWORD" \
   -H "accept: application/json" -o /tmp/foo.txt

status=$?
if [ $status  == 0 ]
then
  grep 'HTTP/1.1 200 OK' /tmp/foo.txt
  status=$?
else
  echo "$(basename $0) Cannot curl $DTR_IP"
fi

if [ $status != 0 ]
then
  echo Cannot find admin/$repo
else
  echo admin/$repo found
fi
exit $status
