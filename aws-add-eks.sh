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

#export AWS_PROFILE=aws-eks

eksctl create cluster -f $2
aws eks --region us-east-1 update-kubeconfig --name $1 $2
#eksctl delete cluster -f $2
