# practica-05-01-daw

## EJ1
```bash
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
```

En este ejercicio se crea un grupo de seguridad llamado backend-sg2 con los puertos 22 y 3306 abiertos y que permitan todo tipo de conexiones.

## EJ2
```bash
#!/bin/bash
set -ex

aws ec2 run-instances \
    --image-id ami-08e637cea2f053dfa \
    --count 1 \
    --instance-type t2.micro \
    --key-name vockey \
    --security-groups backend-sg2 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=backend}]"
```
En este ejercicio se crea una instancia en aws con la imagen de ubuntu, de tipo t2.micro, clave vockey, el grupo de seguridad backend-sg2 y el nombre backend

## EJ3

```bash
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
```
 Se crea un grupo de seguridad llamado ansible con los puertos 22, 3306 y 0-65535 abiertos para todas las conexiones.
```bash
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
```
 Se crea un grupo de seguridad llamado backend-CLI con los puertos 22, 3306, 0-65535 TCP y todos los puertos ICMP abiertos para todas las conexiones.
```

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
```
 Se crea un grupo de seguridad llamado frontend-CLI con los puertos 22, 3306, 443 TCP y todos los puertos ICMP abiertos para todas las conexiones.
```bash
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
```

Se crean tres instancias, cada una con un grupo de seguridad previamente creado distinto, todas con imagen de ubuntu, t2.small y clave vockey.
Se llaman ansible, frontend y backend.
