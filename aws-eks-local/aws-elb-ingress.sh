if [ "$#" -ne 1 ];
then
   echo "Usage error <Aws-Eks-Template.yaml>"
   exit 
fi
cluster_name=`awk '/name:/{print $NF}' $1 |sed -n 1p`
eks_template=$1
aws_region=`awk '/region:/{print $NF}' $1 |sed -n 1p`

echo $cluster_name
echo $eks_template
echo $aws_region

#OPENID
eksctl utils associate-iam-oidc-provider --cluster=$cluster_name --approve
#RBAC
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
policy=`aws iam list-policies |grep -w ALBIngressControllerIAMPolicy`

#create Policy
if [ "$policy" == "" ];
then
   response=aws iam create-policy \
       --policy-name ALBIngressControllerIAMPolicy \
       --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
   arn=`echo $response|awk '/Arn/{print $NF}' |sed -n 1p |sed 's/"//g'|sed 's/,//g'`
else
  arn=`echo $policy |awk '/PolicyName/{print $NF}'|sed 's/"//g'|sed 's/,//g'`
fi

# Create IAMServiceAccount with the policy
eksctl create iamserviceaccount \
    --cluster=$cluster_name  \
    --namespace=kube-system        \
    --name=alb-ingress-controller   \
    --attach-policy-arn=$arn \
    --override-existing-serviceaccounts \
    --approve

echo "deploying the AWS ALB Ingress controller with ARN: $arn"
curl -sS "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml" \
     | sed "s/# - --cluster-name=devCluster/- --cluster-name=$cluster_name/g" \
     | kubectl apply -f -
