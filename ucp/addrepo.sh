#
# Add a repo in DTR
#
script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

repo=$1
if [ "$repo" == "" ]
then
 echo "$0 repo"
 echo "  create a repo in DTR with the specified name" 
 exit 1
else
  echo Creating repo $repo $user at $DTR_IP
fi

token=$(curl -s -k -X POST "https://$UCP_IP/id/login" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"username\": \"${UCP_ADMIN}\",\"password\": \"${UCP_PASSWORD}\"}" | jq -r .sessionToken)


identitytoken=$(curl -s -X POST "https://clh-ucp.cloudra.local/auth" -H  "accept: application/json" -H  "Authorization: Bearer $token" -H  "content-type: application/json" -d "{  \"password\": \"Just4m3hp\",  \"serveraddress\": \"https://clh-dtr.cloudra.local/v0/\",  \"username\": \"Admin\"}" | jq -r .IdentityToken)


curl -s -k -X POST "https://${DTR_IP}/api/v0/repositories/admin" \
   --user "$UCP_ADMIN:$UCP_PASSWORD" \
   -H "accept: application/json" \
   -H "content-type: application/json" \
   -d "{ \"enableManifestLists\": true, \"immutableTags\": true, \"longDescription\": \"$0 $repo\", \"name\": \"$repo\", \"scanOnPush\": true, \"shortDescription\": \"test repo\", \"visibility\": \"public\"}"
