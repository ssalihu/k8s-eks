if [ "$#" -ne 1 ];
then
   echo "Usage error <Aws-Eks-Template.yaml>"
   exit 
fi
eks_template=$1
eksctl delete cluster -f $eks_template
