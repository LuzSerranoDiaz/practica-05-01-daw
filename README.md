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

## EJ4

```bash
#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""
```
Se deshabilita la paginacion de la salida de los comandos de AWS CLI
```

# Variables de configuración
AMI_ID=ami-0c7217cdde317cfec
COUNT=1
INSTANCE_TYPE=t2.small
KEY_NAME=vockey

SECURITY_GROUP_FRONTEND=frontend-sg
SECURITY_GROUP_BACKEND=backend-sg

INSTANCE_NAME_LOAD_BALANCER=load-balancer
INSTANCE_NAME_FRONTEND=frontend
INSTANCE_NAME_BACKEND=backend

```
Variables de configuracion.
```

# Creamos una intancia EC2 para el frontend
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_FRONTEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_FRONTEND}]" \
    --user-data "sudo apt update && sudo apt upgrade -y"

# Creamos una intancia EC2 para el backend
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count $COUNT \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP_BACKEND \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME_BACKEND}]" \
    --user-data "sudo apt update && sudo apt upgrade -y"
```
Se crean dos instancias, frontend y backend, de ubuntu, t2.small, con clave vockey y con sus grupos de seguridad respectivos.

Cada instancia ejecuta al iniciarse los comandos `sudo apt update && sudo apt upgrade -y` para actualizar los paquetes del sistema.
