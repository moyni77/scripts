source MYCA.RC
rootca=${ROOTCA}
rootca_desc=${ROOTCA_DESC}
rootca_ttl=${ROOTCA_TTL}
rootca_endpoint=${ROOTCA_ENDPOINT}

mycaint=${INTCA}
mycaint_ttl=${INTCA_TTL}
mycaint_desc=${INTCA_DESC}
mycaint_endpoint=${INTCA_ENDPOINT}

mycaint_csr="mycaint.csr"
mycaint_cert="mycaint.cert"

#
# Mount the root CA
#
echo Mouting $rootca
vault mount -path=${rootca} -description="${rootca_desc}" -max-lease-ttl=${rootca_ttl} pki
echo Generating Root CA certificate
vault write ${rootca}/root/generate/internal \
    common_name="${rootca_desc}" \
    ttl=${rootca_ttl} \
    key_bits=4096 \
    exclude_cn_from_sans=true >/dev/null

echo Configuring Root CA URLs
vault write ${rootca}/config/urls issuing_certificates="${rootca_endpoint}"


echo Retrieving the Root CA certificate
curl -s ${rootca_endpoint}/ca/pem | openssl x509 -text | openssl x509 -text | head -20

echo Mounting $mycaint
vault mount \
    -path=${mycaint} \
    -description="${mycaint_desc}" \
    -max-lease-ttl=${mycaint_ttl} \
    pki


echo Generating a CSR for the Intermediate CA
vault write --format=json ${mycaint}/intermediate/generate/internal \
    common_name="${mycaint_desc}" \
    ttl=${mycaint_ttl} \
    key_bits=4096 exclude_cn_from_sans=true \
    | jq -r .data.csr > ${mycaint_csr}

echo Signing the Intermediate CA CSR
vault write --format=json ${rootca}/root/sign-intermediate \
  csr=@${mycaint_csr}  \
  common_name="${mycaint_desc}" \
  ttl=${mycaint_ttl} \
  | jq -r .data.certificate > ${mycaint_cert}

echo Storing the signed certificate in the Intermediate CA
vault write ${mycaint}/intermediate/set-signed \
 certificate=@${mycaint_cert}


echo Configuring Intermediate CA URLs
vault write ${mycaint}/config/urls issuing_certificates="${mycaint_endpoint}"

#verify the certificate
curl -sk ${mycaint_endpoint}/ca/pem | openssl x509 -text -noout | head -20

#
# do some cleanup
#
if [ -f ${mycaint_csr} ]  ; then rm -f ${mycaint_csr} ; fi
if [ -f ${mycaint_cert} ] ; then rm -f ${mycaint_cert} ; fi

