script_dir=$(dirname $0)
. ${script_dir}/vars.rc

#
# Create $imax PVs and the corresponding PVCs
#
pv_file=/tmp/pv.yml
pvc_file=/tmp/pvc.yml

for (( i = 1 ; i <= imax ; i++ ))
do
#
# Create the persistent volume
#
  i=$i techno=$techno envsubst < ./pv.tpl >${pv_file}
  kubectl apply -f ${pv_file}

#
# create the persistent volume claim
#
  i=$i techno=$techno envsubst < ./pvc.tpl >${pvc_file}
  kubectl apply -f ${pvc_file}

done

