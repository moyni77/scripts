script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

curdir=${PWD}
cd $CERTS_DIR
. ./env.sh
cd $curdir

what=$1
what=${what,,}
case "$what" in
 "start")
    cont=$(docker ps | awk '/busybee/ {print $1}')
    if [ "$cont" == "" ]
    then
      docker run -d  -e constraint:ostype==linux --name busybee alpine sh -c 'while [ 1 == 1 ] ; do : ; done'
      cont=$(docker ps | awk '/busybee/ { print $NF }')
      echo "Bee busy on ${cont}"

    else
      cont=$(docker ps | awk '/busybee/ { print $NF }')
      echo "Bee already busy on ${cont}"
    fi
   ;;
 "stop")
    cont=$(docker ps | awk '/busybee/ {print $1}')
    if [ "$cont" != "" ]
    then
      docker rm -f $cont
    else
      echo no bee found
    fi
   ;;
 *)
   echo usage "$(basename $0) start|stop"
   ;;
esac

