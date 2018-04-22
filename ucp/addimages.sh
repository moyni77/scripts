#
# Add images in DTR
#
script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

repo=$1
if [ "$repo" == "" ]
then
 echo "$0 repo"
 echo "  Add alpine:2.6 and alpine:3.4  to the specified repo" 
 exit 1
else
  echo Add alpine:2.6 and alpine:3.4 to $DTR_IP
fi

#token=$(curl -s -k -X POST "https://$UCP_IP/id/login" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"username\": \"${UCP_ADMIN}\",\"password\": \"${UCP_PASSWORD}\"}" | jq -r .sessionToken)


#identitytoken=$(curl -s -X POST "https://clh-ucp.cloudra.local/auth" -H  "accept: application/json" -H  "Authorization: Bearer $token" -H  "content-type: application/json" -d "{  \"password\": \"Just4m3hp\",  \"serveraddress\": \"https://clh-dtr.cloudra.local/v0/\",  \"username\": \"Admin\"}" | jq -r .IdentityToken)

curdir=${PWD}
cd $CERTS_DIR
. ./env.sh
cd $curdir
docker login -u $UCP_ADMIN -p "$UCP_PASSWORD" $DTR_IP

docker pull alpine:2.6
imageid=$(docker image inspect alpine:2.6 --format "{{.ID}}")
docker image tag $imageid $DTR_IP/admin/${repo}:2.6
docker image push $DTR_IP/admin/$repo:2.6
 
docker pull alpine:3.4
imageid=$(docker image inspect alpine:3.4 --format "{{.ID}}")
docker image tag $imageid $DTR_IP/admin/${repo}:3.4
docker image push $DTR_IP/admin/$repo:3.4

