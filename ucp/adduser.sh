#
# Create a user in UCP
#
script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

user=$1
if [ "$user" == "" ]
then
 echo "$0 username"
 echo "  create a user in UCP with the specified name" 
 exit 1
else
  echo Creating user $user at $UCP_IP
fi

token=$(curl -s -k -X POST "https://$UCP_IP/id/login" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"username\": \"${UCP_ADMIN}\",\"password\": \"${UCP_PASSWORD}\"}" | jq -r .sessionToken)


curl -k -X POST "https://${UCP_IP}/accounts/" -H  "accept: application/json" -H  "Authorization: Bearer $token" \
       -H  "content-type: application/json" -d \
   "{\"fullName\": \"$0 $user\",\"isActive\": true,\"isAdmin\": false,\"isOrg\": false,\"name\": \"$user\",\"password\": \"Just4m3hp\",\"searchLDAP\": false}"

