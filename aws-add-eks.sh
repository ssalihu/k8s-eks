# install kubectl
curl https://sdk.cloud.google.com | bash > /dev/null
source $HOME/google-cloud-sdk/path.bash.inc
gcloud components install kubectl

# install awscli
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin   

# install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

if [ "$#" -ne 1 ];
then
   echo "Usage error <Aws-Eks-Template.yaml>"
   exit 
fi
#export AWS_PROFILE=aws-eks
cluster_name=`awk '/name:/{print $NF}' $1 |sed -n 1p`
eks_template=$1
aws_region=awk '/region:/{print $NF}' setup-aws-eks.yaml |sed -n 1p
eksctl create cluster -f $cluster_name
aws eks --region $aws_region update-kubeconfig --name $cluster_name $eks_template
#eksctl delete cluster -f $2
