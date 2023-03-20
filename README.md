# UNIR - Devops & Cloud - Caso Práctico 2

## Objetivo:

El alcance de la práctica desarrollada es un despliegue en Terraform y Ansible, con los siguientes objetivos:
- Crear una **máquina virtual **con un servidor web desplegado sobre **podman**, incluyendo la instalación del mismo.
- Crear un clúster de Kubernetes de Azure (**AKS**)
- Crear un **ACR** (Azure Container Registry) para tener imágenes que se puedan consumir para el despliegue tanto del contenedor necesario en el podman del servidor web, como para los contenedores del despliegue del servidor web que albergará el clúster AKS. Por simplicidad y limpieza, se ha optado por enfocar ambos despligues con el mismo software, en este caso de nginx, pero con comporatmientos y tipos de despliegue, diferentes.

## Versiones utilizadas:

Para el desarrollo y pruebas de despliegue, se han utilizado las siguientes versiones de **software** desde el host desde donde se lanzan:Azure-cli: 2.45.0Kubectl: 1.23.6Ansible: 2.13.6Terraform: 1.3.8Python: 3.9.16Jinja: 3.1.2 (en los scripts utilizados, no se ha utilizado finalmente)**Providers** de Terraform utilizados:hashicorp/azurerm
hashicorp/random (utilizado para el nombre aleatorio del grupo de recursos)**Módulos** de Ansible utilizados:
containers.podmankubernetes.core.k8s

## Estructura
La estructura de ficheros es la siguiente:
ansible_practica_2/ansible.cfg : configuración genérica de las conexiones realizadas desde ansibleansible_practica_2/hosts : inventario a rellenar con la ip resultante del despliegue del webserveransible_practica_2/playbook-nginx-podman.yml : playbook utilizado para el despliegue de podman y container de webserver sobre la máquina virtualansible_practica_2/playbook-nginx-k8s-pv.yml : playbook para el despliegue del servidor web sobre el AKS creadoansible_practica_2/roles/ogs.webserver : directorio con el rol para el despliegue de podman y webserveransible_practica_2/roles/ogs.nginx-k8s : directorio con el rol para el despliegue de nginx con almacenamiento persistente en AKSansible_practica_2/roles/ogs.nginx-k8s/vars/main.yml : fichero con las variables a modificar para personalizar el despliegue de nginx sobre AKSansible_practica_2/roles/ogs.nginx-k8s/tasks/main.yml : fichero con las tareas a realizar por el despliegue de nginx sobre AKSansible_practica_2/roles/ogs.nginx-k8s/files/aksconfig : fichero kubeconfig requerido para la conexión con el cluster AKSansible_practica_2/roles/ogs.nginx-k8s/files/k8s_manifest : directorio con el manifiesto del despliegue nginx-pv-deployment.yaml , donde podrían ir todos aquellos manifiestos adicionales a ejecutaransible_practica_2/roles/ogs.webserver/tasks : directorio que contiene los yml con las tareas necesarias para el despliegueansible_practica_2/templates: sin uso en este casoansible_practica_2/deploy.sh: fichero que ejecuta primero el playbook del webserver sobre podman en la máquina virtual , y luego el playbook del despliegue de nginx con almacenamiento persistente sobre AKSansible_practica_2/vars: en este caso las variables se definen en los ficheros de variables de cada rolterraform: directorio con todos los ficheros con código de Terraform, con un nombre descriptivo en cuanto a su función, siendo el main.tf el fichero en el cual se declara el grupo de recursos a utilizar

## Uso de Terraform 

### Tareas previas al lanzamiento de los scripts de Terraform:
Con la premisa de tener, en primer lugar configurada la cuenta de Azure Student requerida, e instaladas las versiones de Azure CLI, kubectl, Ansible, y Terraform, descritas en el punto 2 de este informe, bien sobre una máquina virtual, o bien sobre el propio portátil del estudiante, se requiere seguir los siguientes pasos para la preparación antes de la ejecución de los scripts desarrollados:
**Keys**:- Creación de par de claves para la conexión posterior por ssh requerida por ansible, para ello, y como sugerencia, se podría lanzar el siguiente comando: `ssh-keygen -t rsa` , dejando la passphrase vacía en este caso, y especificando los nombres az_vm_unir.pem para la clave privada, y az_vm_unir.pub, para la pública- comprobar que ha dejado las claves en el directorio $HOME/.ssh/- dentro de ansible_practica_2/ansible.cfg , se modificará la siguiente línea (en caso de ser necesario): private_key_file = ~/.ssh/az_vm_unir.pem**Sistema**:- Aceptar los términos de uso de la imagen Rocky 9.1 para poder utilizarla en la máquina virtual:


`az vm image terms show --urn erockyenterprisesoftwarefoundationinc1653071250513:rockylinux-9:rockylinux-9:latest`
`az vm image terms accept ----`
**Entidad de servicio:**- Crear entidad de servicio con un rol de Contributor:
 
`az ad sp create-for-rbac --name OGS-Unirp2 --role Contributor --scopes /subscriptions/<ID subscription>`
**Variables:**
- Editar el fichero vars.tf para personalizar el nombre del cluster, nombre de la máquina virtual, y ubicación de la key en caso de no ser la indicada en el paso anterior de “- keys”.### Lanzamiento de los scripts de Terraform:

Generación de fichero con el plan: 

`terraform plan -out main.tfplan`Lanzamiento del plan: 

`terraform apply "main.tfplan"`

El propio script de terraform se encarga de enlazar el ACR con el clúster AKS creado, y de dejar en ese ACR una imagen en base a la última versión de nginx oficial.
Para comprobar el acceso al clúster, se debe generar el fichero kubeconfig a utilizar, en este caso se nombra como aksconfig y se deja en el directorio del rol de ansible que se utilizará en el paso posterior:
`echo "$(terraform output kube_config)" > ../ansible_practica_2/roles/ogs.nginx-k8s/files/aksconfig`
Nota: hay que eliminar de manera manual las entradas ”EOT” que deja tanto en el inicio como al final del fichero aksconfig resultantese carga la variable KUBECONFIG para lanzar comandos con kubectl:

` export KUBECONFIG=../ansible_practica_2/roles/ogs.nginx-k8s/files/aksconfig`

## Uso de Ansible


### Tareas previas al lanzamiento de los scripts de Ansible:
- Kubeconfig:
Comprobar que se tiene el fichero aksconfig con el contenido del kubeconfig del clúster AKS creado, en el directorio: ansible_practica_2/roles/ogs.nginx-k8s/files/aksconfig, como se describe en el paso anterior (paso 5) en su parte final.
- Ip webserver:
Editar el fichero “hosts” del directorio ansible_practica_2 , con la ip resultante de la máquina virtual “webserver” desplegada por el terraform (se puede consultar directamente en la web, como se puede ver en la captura de pantalla donde se muestra la máquina virtual), quedando de la siguiente manera (ejemplo):
[web-servers]13.81.219.115
- Instalación de la colección kubernetes.core requerida: 

`ansible-galaxy collection install kubernetes.core`
- Variables:
Editar el fichero: ansible_practica_2/roles/ogs.webserver/tasks/install_webserver.yml , con la ubicación de la imagen a desplegar en caso de haber cambiado el nombre del ACR desplegado:Editar el fichero: ansible_practica_2/roles/ogs.nginx-k8s/vars/main.yml , en base a:Kubeconfig: ‘aksconfig’ (en caso de haber cambiado el nombre del kubeconfig)K8s_namespace: ‘nginx’ (si se quiere crear con otro nombre)K8s_manifest_dir: ‘k8s_manifest’ (donde se alojan los manifiestos)Manifest_file: ‘nginx-pv-deployment.yaml’ (si se utiliza otro)El tamaño del volumen utilizado por el despliegue de nginx con almacenamiento persistente sobre AKS, es posible modificarlo en el fichero nginx-pv-deployment.yaml
### Lanzamiento de los scripts de Ansible:

Basta con ejecutar el script deploy.sh ubicado en la carpeta ansible_practica_2/ : 

`./deploy.sh`


## License

MIT License

Copyright (c) 2023 Óscar García Sarmiento

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



