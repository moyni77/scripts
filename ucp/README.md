# Automate some repetitive tasks related to Docker

## Configure the scripts

```
git clone <this repo>
cd scripts/ucp
```

edit the file mycloud.rc for it to reflect your environment

```
CLOUD=${CLOUD:-clh}
UCP_IP="$CLOUD-ucp.cloudra.local"
UCP_ADMIN="Admin"
UCP_PASSWORD="Just4m3hp"
CERTS_DIR=~/certs.$CLOUD
DTR_IP="$CLOUD-dtr.cloudra.local"
```

Example: If you are Nick (environment = nm-ucp01 etc...) (put your own password)

```
CLOUD=${CLOUD:-nm}
UCP_IP="$CLOUD-ucp.cloudra.local"
UCP_ADMIN="Admin"
UCP_PASSWORD="youpass"
CERTS_DIR=~/certs.$CLOUD
DTR_IP="$CLOUD-dtr.cloudra.local"
```

For the remaining of this readme, I will assume CLOUD='clh'

## Retrieve a client bundle for your cloud
```
cd ~/scripts/ucp
./get-bundle
```
This will create a folder named ~/certs.clh (again we assume that CLOUD='clh'). If your workstation has docker install, when you use the docker command you interact with your docker cluster

```
cd ~/certs.clh
. env.sh
```

You can then issue docker commands which will be executed on your Docker cluster

```
[root@clh2-ansible ucp]# docker node ls
ID                          HOSTNAME                   STATUS AVAILABILITY MANAGER STATUS
3v3n926suh8g5d2k992zodm1m   clh-dtr01.cloudra.local    Ready  Active
6cmglq33lqawh8qtzm2jvcv69   clh-worker01.cloudra.local Ready  Active
hge7jeqmuvtg87ewyz2v97fmf   clh-ucp01.cloudra.local    Ready  Active       Leader
io72n13tqbkb7dd72b0zuvupx * clh-ucp03.cloudra.local    Ready  Active       Reachable
oug0yq6n7d8jui2frs28d8d58 clh-ucp02.cloudra.local      Ready  Active       Reachable
```

## Add a user to UCP
```
cd ~/scripts
cd ucp
./adduser.sh christophe
```

This will create a user named `christophe` if it does not already exists, and produce some output

```
Creating user christophe at clh-ucp.cloudra.local
{
	"name": "christophe",
	"id": "2aa34a06-8213-4493-a396-dff781d774ca",
	"fullName": "./adduser.sh christophe",
	"isOrg": false,
	"isAdmin": false,
	"isActive": true,
	"isImported": false
}
```

And here is what happens if you try to create the same user again

```
[root@clh2-ansible ucp]# ./adduser.sh christophe
Creating user chris at clh-ucp.cloudra.local
{
	"errors": [
	{
		"code": "ACCOUNT_EXISTS",
		"message": "An account with the same name already exists."
		}
	]
	}[root@clh2-ansible ucp]#
```

## Adding a repo to DTR

```
./addrepo repo
```

This will create a repo with the specified name in the admin namespace (/admin/repo)

Example: (Success)

```
[root@clh2-ansible ucp]# ./addrepo.sh myrepo
Creating repo myrepo at clh-dtr.cloudra.local
{
  "id": "34da2da3-859d-4a6f-b698-e442ed5749c4",
  "namespace": "admin",
  "namespaceType": "user",
  "name": "myrepo",
  "shortDescription": "test repo",
  "longDescription": "./addrepo.sh myrepo",
  "visibility": "public",
  "scanOnPush": true,
  "immutableTags": true,
  "enableManifestLists": true
}
```

Example: the specified repo already exists

```
[root@clh2-ansible ucp]# ./addrepo.sh myrepo
Creating repo myrepo at clh-dtr.cloudra.local
{
  "errors": [
   {
    "code": "REPOSITORY_EXISTS",
    "message": "A repository with the same name already exists."
   }
  ]
 }[root@clh2-ansible ucp]#
```

## Push alpine:2.6 and alpine 3.4 to an existing repo
```
./addimages repo
```
This will push the images alpine:2.6 and alpine:3.4 in the specified repo

Example: 

```
[root@clh2-ansible ucp]# ./addimages.sh myrepo
Add alpine:2.6 and alpine:3.4 to clh-dtr.cloudra.local
Login Succeeded
clh-dtr01.cloudra.local: Pulling alpine:2.6...
clh-ucp02.cloudra.local: Pulling alpine:2.6...
clh-ucp03.cloudra.local: Pulling alpine:2.6...
clh-worker02.cloudra.local: Pulling alpine:2.6...
clh-ucp01.cloudra.local: Pulling alpine:2.6...
clh-worker01.cloudra.local: Pulling alpine:2.6...
clh-worker02.cloudra.local: Pulling alpine:2.6... : Pulling from library/alpine
clh-worker02.cloudra.local: Pulling alpine:2.6... : Already exists
clh-worker02.cloudra.local: Pulling alpine:2.6... : Digest: sha256:e9cec9aec697d8b9d450edd32860ecd363f2f3174c8338beb5f809422d182c63
clh-worker02.cloudra.local: Pulling alpine:2.6... : Status: Image is up to date for alpine:2.6
clh-worker02.cloudra.local: Pulling alpine:2.6...
clh-worker01.cloudra.local: Pulling alpine:2.6... : Pulling from library/alpine
clh-worker01.cloudra.local: Pulling alpine:2.6... : Already exists
clh-worker01.cloudra.local: Pulling alpine:2.6... : Digest: sha256:e9cec9aec697d8b9d450edd32860ecd363f2f3174c8338beb5f809422d182c63
            :                :                    :
clh-worker01.cloudra.local: Pulling alpine:3.4... : Status: Image is up to date for alpine:3.4
clh-worker01.cloudra.local: Pulling alpine:3.4...
clh-ucp02.cloudra.local: Pulling alpine:3.4...
clh-dtr01.cloudra.local: Pulling alpine:3.4... : Digest: sha256:2532609239f3a96fbc30670716d87c8861b8a1974564211325633ca093b11c0b
clh-dtr01.cloudra.local: Pulling alpine:3.4... : Status: Image is up to date for alpine:3.4
clh-dtr01.cloudra.local: Pulling alpine:3.4...
The push refers to a repository [clh-dtr.cloudra.local/admin/myrepo]
e53f74215d12: Pushed
3.4: digest: sha256:2441496fb9f0d938e5f8b27aba5cc367b24078225ceed82a9a5e67f0d6738c80 size: 528
```

After a successful push you should see two images in the admin/alpine repo (need to use the DTR UI for now). if you have vulnerability scanning enabled, alpine:2.6 shows critical errors, alpine:3.4 does not show critical errors (at the time of writing)

## Verify the presence of a repo
Verifies the presence of the repo admin/`repo` in your DTR registry

```
./chkrepo repo
```
exit code is 0 if the repo exists, !0 otherwise

## Verify the presence of a tag in a repo 
Verifies the presence of specified `tag` in the repo admin/`repo` in your DTR registry

```
./chktags <repo> <tag>

exit code is 0 if the specified tag exists in the repo, !0 otherwise
```

