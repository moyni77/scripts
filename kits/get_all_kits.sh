#
# Docker UCP and Docker DTR
#
wget https://packages.docker.com/caas/ucp_images_2.2.9.tar.gz -O ucp.2.2.9.tar.gz
wget https://packages.docker.com/caas/ucp_images_3.0.0.tar.gz -O ucp.3.0.0.tar.gz
wget https://packages.docker.com/caas/dtr_images_2.4.3.tar.gz -O dtr.2.4.3.tar.gz
wget https://packages.docker.com/caas/dtr_images_2.5.0.tar.gz -O dtr.2.5.0.tar.gz

#
# Splunk stuff
#
SPLUNK_PRODUCT=splunk
SPLUNK_VERSION=7.0.2
SPLUNK_BUILD=03bbabbd5c0f
SPLUNK_FILENAME=splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz
wget https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}

SPLUNK_PRODUCT=splunk
SPLUNK_VERSION=7.0.3
SPLUNK_BUILD=fa31da744b51
SPLUNK_FILENAME=splunk-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz
wget https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}

SPLUNK_PRODUCT=universalforwarder
SPLUNK_VERSION=7.0.3
SPLUNK_BUILD=fa31da744b51
SPLUNK_FILENAME=splunkforwarder-${SPLUNK_VERSION}-${SPLUNK_BUILD}-Linux-x86_64.tgz
wget https://download.splunk.com/products/${SPLUNK_PRODUCT}/releases/${SPLUNK_VERSION}/linux/${SPLUNK_FILENAME}

#
# kubectl
#
version=v1.11.1
wget -O kubectl.v1.11.1  https://storage.googleapis.com/kubernetes-release/release/${version}/bin/linux/amd64/kubectl
