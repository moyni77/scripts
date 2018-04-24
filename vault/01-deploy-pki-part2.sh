source MYCA.RC

mycaint=${INTCA}
mycaint_ttl=${INTCA_TTL}
mycaint_desc=${INTCA_DESC}
mycaint_endpoint=${INTCA_ENDPOINT}
echo $mycaint_endpoint
return
mycaint_csr="mycaint.csr"
mycaint_cert="mycaint.csr.pem"


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
#if [ -f ${mycaint_csr} ]  ; then rm -f ${mycaint_csr} ; fi
#if [ -f ${mycaint_cert} ] ; then rm -f ${mycaint_cert} ; fi

