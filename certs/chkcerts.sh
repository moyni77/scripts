ckcert=$(openssl x509 -noout -modulus -in cert.pem | openssl md5)
ckkey=$(openssl rsa -noout -modulus -in key.pem| openssl md5)
if [ "$ckkey" == "$ckcert" ]
then 
  echo "Private key and Certificate match"
else 
  echo "STOP! Private Key and Certificate don't match"
fi

intca=$(mktemp)
sed -e '1,/-----END CERTIFICATE-----/d' cert.pem > $intca
 
cachain=$(mktemp)
cat $intca ca.pem > $cachain
 
openssl verify -verbose -CAfile $cachain  cert.pem
if [ $? == 0 ]
then
  echo OK Certificate is signed by the supplied CA ca.pem
else
  echo "STOP: cert.pem is not signed by ca.pem" 
fi
