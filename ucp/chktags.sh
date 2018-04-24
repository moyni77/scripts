#
# Verifies that the repository contains two predefined tages (2.6 and 3.4)
#
script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

repo=$1
tag=$2

if [ "$repo" == "" ] || [ "$tag" == "" ]
then
 echo "$0 repo tag"
 echo "  verifies that the image admin/repo:tag  exists in $DTR_IP"
 exit 1
fi

token=$(curl -s -k -X POST "https://$UCP_IP/id/login" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"username\": \"${UCP_ADMIN}\",\"password\": \"${UCP_PASSWORD}\"}" | jq -r .sessionToken)


echo Verifying presence of admin/$repo:2.6 in $DTR_IP
curl -i -s -k -X GET "https://${DTR_IP}/api/v0/repositories/admin/$repo/tags/${tag}" \
   --user "$UCP_ADMIN:$UCP_PASSWORD" \
   -H "accept: application/json" -o /tmp/foo.txt

status=$?
if [ $status  == 0 ]
then
  grep 'HTTP/1.1 200 OK' /tmp/foo.txt >/dev/null
  status=$?
else
  echo "$(basename $0) Cannot curl $DTR_IP"
fi

if [ $status != 0 ]
then
  echo Cannot find admin/$repo:${tag}
else
  echo Found admin/$repo:${tag}
fi
exit $status
