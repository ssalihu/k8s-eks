mkdir -p ~/.aws
openssl aes-256-cbc -K $encrypted_dfba7aade086_key -iv $encrypted_dfba7aade086_iv -in config.enc -out ~/.aws/config -d
openssl aes-256-cbc -K $encrypted_d506bd5213c4_key -iv $encrypted_d506bd5213c4_iv -in credentials.enc -out ~/.aws/credentials -d
export AWS_PROFILE=aws-eks

eksctl create cluster -f ekssetup-course.yaml
aws eks --region us-east-1 update-kubeconfig --name EmployeeTestCluster
eksctl delete cluster -f ekssetup-course.yaml
