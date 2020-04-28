eksctl utils associate-iam-oidc-provider --cluster=$1 --approve
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
policy=`aws iam list-policies |grep -w ALBIngressControllerIAMPolicy`
if [ "$policy" == "" ];
then
   aws iam create-policy \
       --policy-name ALBIngressControllerIAMPolicy \
       --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
fi

echo "deploying the AWS ALB Ingress controller"
curl -sS "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml" \
     | sed "s/# - --cluster-name=devCluster/- --cluster-name=$1/g" \
     | kubectl apply -f -
