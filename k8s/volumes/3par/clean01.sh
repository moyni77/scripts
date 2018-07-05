#
# test 3par volume plugin
#
CERTS_DIR=~/certs.clh

curdir=${PWD}
cd $CERTS_DIR
. ./env.sh
cd $curdir


imax=10
for (( i=1 ; i <= imax ; i++ ))
do
  echo Killing nginx$i
  docker kill nginx$i
done


for (( i=1 ; i <= imax ; i++ ))
do
  echo Deleting nginx$i
  docker rm nginx$i
done


for (( i=1 ; i <= imax ; i++ ))
do
  echo Deleting volume test_vol$i
  ssh clh-worker01 docker volume rm test_vol$i
done
