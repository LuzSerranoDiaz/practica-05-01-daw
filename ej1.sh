#!/bin/bash
set -ex

aws ec2 create-security-group \
    --group-name backend-sg2 \
    --description "Reglas para el backend"

aws ec2 authorize-security-group-ingress \
    --group-name backend-sg2 \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name backend-sg2 \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0