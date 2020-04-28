# Setup AWS keys and create a EKS cluster
mkdir -p ~/.aws
openssl aes-256-cbc -K $encrypted_dfba7aade086_key -iv $encrypted_dfba7aade086_iv -in config.enc -out ~/.aws/config -d
openssl aes-256-cbc -K $encrypted_d506bd5213c4_key -iv $encrypted_d506bd5213c4_iv -in credentials.enc -out ~/.aws/credentials -d

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
