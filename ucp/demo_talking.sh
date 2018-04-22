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
    cont=$(docker ps | awk '/talkingjay/ {print $1}')
    if [ "$cont" == "" ]
    then
      docker run -d  --name talkingjay alpine sh -c 'while [ 1 == 1 ] ; do echo jaybird talking ; sleep 3 ; done'
      cont=$(docker ps | awk '/talkingjay/ { print $NF }')
      echo "bird now talking on ${cont}"
    else
      cont=$(docker ps | awk '/talkingjay/ { print $NF }')
      echo "bird already talking on ${cont}"
    fi
   ;;
 "stop")
    cont=$(docker ps | awk '/talkingjay/ {print $1}')
    if [ "$cont" != "" ]
    then
      docker rm -f $cont
    else
      echo no bird found
    fi
   ;;
 *)
   echo usage "$(basename $0) start|stop"
   ;;
esac

