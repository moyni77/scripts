arg=$1
if [ "$1" == "" ]
then
  echo usage: $(basename $0) nameset
  exit
fi
echo Creating context for $arg
CURRENT_CONTEXT=$(kubectl config view -o jsonpath='{.current-context}')
echo $CURRENT_CONTEXT
CLUSTER_NAME=$(kubectl config view -o jsonpath='{.contexts[?(@.name == "'"${CURRENT_CONTEXT}"'")].context.cluster}')
USER_NAME=$(kubectl config view -o jsonpath='{.contexts[?(@.name == "'"${CURRENT_CONTEXT}"'")].context.user}')
kubectl config set-context $arg --namespace=$arg --cluster=${CLUSTER_NAME} --user=${USER_NAME}
echo "'kubectl config use-context $arg'"  to change context
