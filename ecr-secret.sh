ACCOUNT=813354974303 # to be changed for env
REGION=us-east-1
NAMESPACE=ggeply
SECRET_NAME=ecr-secret
EMAIL=email@email.com
PROFILE=k8suser #placed for security reasons, as docker strings below were giving error

#
# Fetch token (which will expire in 12 hours)
#

TOKEN=`aws ecr --profile=$PROFILE --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`

#
# Create or replace registry secret
#

kubectl delete secret --ignore-not-found $SECRET_NAME -n $NAMESPACE
kubectl create secret docker-registry $SECRET_NAME -n $NAMESPACE \
 --docker-server=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
 --docker-username=AWS \
 --docker-password="${TOKEN}" \
 --docker-email="${EMAIL}"
echo "Secret created by name. $SECRET_NAME"
