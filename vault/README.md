1- install  the vault binary

2- install jq (sudo apt install jq)

3- edit MYCA.RC
    edit IP Adresses and endpoints 
      (use http for endpoints unless you have an existing CA infra with certificates)

4- start vault using vault.notls.hcl
      you may want to change the backend, we are using the "file" backend
      # vault server -config vault.notls.hcl

5- Initiaalise the vault
     The first time a vault is started, the backend is empty and the vault must be initialized

     # export VAULT_ADDR=http://<yourip>:8200
     # vault init
	take note of the unseal keys and root token, if you lose them, you are doomed

6- You need to unseal the vault each time the server is started (or after init)

     # vault unseal 
	typically you need to run this command three times using a different unseal key to unseal the vault

7- authenticate
     # vault auth
	(enter the token which was output when running "vault init" )

8- Create your PKI INfra (you only need to this once)
     # ./00-deploy-pki.sh

9- Create 2 roles that will let you issue server and client certificates (you only need to run this once)
     # ./10-deploy-roles.sh


10- Create a token that you can pass to other users
     # ./20-get-token.sh

     You can run this command as many times as you want, a new token will be created that you can give
     to your customers (people willing to create certificates server and/or client certificates)

If you did not have TLS certificates and keys for use by your vault server and started using simple http: 
here is what you should do to produce a server certificate for use by the vault server itself (not 
recommended but this is what I do all the time)

1-    generate a server certificate for the server hosting vault using  40-get-server-certs.sh
2-    edit vault.tls.hcl and take note of the location of the certificates. place the certificates
           where you wannt but make sure vault.tls.hcl is specifying the good names and location
3-    stop vault (ctrl -C or kill )
4-    start vault using vault.tls.hcl and unseal the vault
	 # vault server -config <configfile>
         # vault unseal (using the unsel keys)
5-    edit MYCA.RC changing the endpoints (http:// -> htts://)


NOTE: the script 40-get-server-certs.sh is meant to run on the machine which will use
   the TLS certificate and private key. It is easy enough to change to create certificates for other machines
   
Self-Service

Now, provided you have been granted a token (See step -10-) copy the scripts on your target machine
and use 30-get-client-bundle.sh of 40-get-server-cert.sh to generate client/server certificates

to get a copy of the rootca and intermediate cert

 curl  -k ${ROOTCA_ENDPOINT}/ca/pem
 curl  -k ${INTCA_ENDPOINT}/ca/pem
