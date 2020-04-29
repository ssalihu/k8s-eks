#!/bin/bash
# If aws cli eksctl has been installed just use this script
# 
if [ "$#" -ne 1 ];
then
   echo "Usage error <Aws-Eks-Template.yaml>"
   exit 
fi

cluster_name=`awk '/name:/{print $NF}' $1 |sed -n 1p`
eks_template=$1
aws_region=awk '/region:/{print $NF}' setup-aws-eks.yaml |sed -n 1p

eksctl create cluster -f $eks_template
aws eks --region  $aws_region update-kubeconfig --name $cluster_name $eks_template
#eksctl delete cluster -f $2
