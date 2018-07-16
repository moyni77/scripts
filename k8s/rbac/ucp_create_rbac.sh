#!/bin/bash

# set environment variables
USERNAME="admin"
PASSWORD="docker123"
UCP_URL="10.1.2.3:4443"

# get auth token
AUTH_TOKEN="$(curl -sk -d '{"username":"'${USERNAME}'","password":"'${PASSWORD}'"}' https://${UCP_URL}/auth/login | jq -r .auth_token 2>/dev/null)"

CURL_OPTS=(-ks --header "Content-Type: application/json" --header "Accept: application/json" -H "Authorization: Bearer ${AUTH_TOKEN}")

# create organization
curl -X POST "${CURL_OPTS[@]}" -d '{"name":"demo-org","isOrg":true}' "https://${UCP_URL}/accounts/"

# create team
curl -X POST "${CURL_OPTS[@]}" -d '{"name":"demo-team","description":"Demo Team"}' "https://${UCP_URL}/accounts/demo-org/teams"

# create users, if necessary
if [ "$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/api/accounts" | jq -r '.[] | select (.username == "demo") | .username')" != "demo" ]
then
  curl -X POST "${CURL_OPTS[@]}" -d '{"name":"demo","password":"docker123","fullName":"Demo User","isAdmin":true,"isActive":true}' "https://${UCP_URL}/accounts/"
fi

if [ "$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/api/accounts" | jq -r '.[] | select (.username == "demo2") | .username')" != "demo2" ]
then
  curl -X POST "${CURL_OPTS[@]}" -d '{"name":"demo2","password":"docker123","fullName":"Demo User2","isAdmin":false,"isActive":true}' "https://${UCP_URL}/accounts/"
fi

# add members to team
curl -X PUT "${CURL_OPTS[@]}" -d "{}" "https://${UCP_URL}/accounts/demo-org/teams/demo-team/members/demo"
curl -X PUT "${CURL_OPTS[@]}" -d "{}" "https://${UCP_URL}/accounts/demo-org/teams/demo-team/members/demo2"

# create collections
curl -X POST "${CURL_OPTS[@]}" -d '{"name":"demo-collection","parent_id":"swarm"}' "https://${UCP_URL}/collections"
COLLECTION_ID="$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/collections/swarm/children?limit=0" | jq -r '.[] | select (.path == "/demo-collection") | .id')"

curl -X POST "${CURL_OPTS[@]}" -d '{"name":"dev","parent_id":"'"${COLLECTION_ID}"'"}' "https://${UCP_URL}/collections"
curl -X POST "${CURL_OPTS[@]}" -d '{"name":"test","parent_id":"'"${COLLECTION_ID}"'"}' "https://${UCP_URL}/collections"
curl -X POST "${CURL_OPTS[@]}" -d '{"name":"prd","parent_id":"'"${COLLECTION_ID}"'"}' "https://${UCP_URL}/collections"

# create a grant
TEAM_ID="$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/accounts/demo-org/teams/demo-team" | jq -r .id)"
PARENT_COLLECTION_ID="$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/collections/swarm/children?limit=0" | jq -r '.[] | select (.path == "/demo-collection") | .id')"

COLLECTION_ID="$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/collections/${PARENT_COLLECTION_ID}/children?limit=0" | jq -r '.[] | select (.path == "/demo-collection/dev") | .id')"
curl -X PUT "${CURL_OPTS[@]}" -d "{}" "https://${UCP_URL}/collectionGrants/${TEAM_ID}/${COLLECTION_ID}/fullcontrol"

COLLECTION_ID="$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/collections/${PARENT_COLLECTION_ID}/children?limit=0" | jq -r '.[] | select (.path == "/demo-collection/test") | .id')"
curl -X PUT "${CURL_OPTS[@]}" -d "{}" "https://${UCP_URL}/collectionGrants/${TEAM_ID}/${COLLECTION_ID}/restrictedcontrol"

COLLECTION_ID="$(curl "${CURL_OPTS[@]}" "https://${UCP_URL}/collections/${PARENT_COLLECTION_ID}/children?limit=0" | jq -r '.[] | select (.path == "/demo-collection/prd") | .id')"
curl -X PUT "${CURL_OPTS[@]}" -d "{}" "https://${UCP_URL}/collectionGrants/${TEAM_ID}/${COLLECTION_ID}/viewonly"
