#!/bin/bash
set -ex

#grupos de seguridad
#principal
aws ec2 create-security-group \
    --group-name ansible \
    --description "Reglas para el ansible"

aws ec2 authorize-security-group-ingress \
    --group-name ansible \
    --protocol tcp \
    --port 0-65535 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name ansible \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name ansible \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0

#backend
aws ec2 create-security-group \
    --group-name backend-CLI \
    --description "Reglas para el backend"

aws ec2 authorize-security-group-ingress \
    --group-name backend-CLI \
    --protocol tcp \
    --port 0-65535 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name backend-CLI \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name backend-CLI \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name backend-CLI \
    --protocol icmp \
    --port -1 \
    --cidr 0.0.0.0/0

#frontend
aws ec2 create-security-group \
    --group-name frontend-CLI \
    --description "Reglas para el frontend"

aws ec2 authorize-security-group-ingress \
    --group-name frontend-CLI \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name frontend-CLI \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name frontend-CLI \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name frontend-CLI \
    --protocol icmp \
    --port -1 \
    --cidr 0.0.0.0/0

#instancias
aws ec2 run-instances \
    --image-id ami-0c7217cdde317cfec \
    --count 1 \
    --instance-type t2.small \
    --key-name vockey \
    --security-groups ansible \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ansible}]"

aws ec2 run-instances \
    --image-id ami-0c7217cdde317cfec \
    --count 1 \
    --instance-type t2.small \
    --key-name vockey \
    --security-groups frontend-CLI \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=frontend}]"

aws ec2 run-instances \
    --image-id ami-0c7217cdde317cfec \
    --count 1 \
    --instance-type t2.small \
    --key-name vockey \
    --security-groups backend-CLI \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=backend}]"