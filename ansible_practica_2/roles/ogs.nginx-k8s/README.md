Despliegue de nginx con almacenamiento persistente en AKS
=========

Este rol se crea con el fin de albergar las actividades relacionadas con el dspliegue de una app sencilla, como nginx, con un volúmen persistente, y utilizando una imágen ubicada en el Azure Container Registry utilizado en el grupo de recursos.

Requisitos
------------

Para las pruebas se han utilizado las siguientes versiones: 
ansible-playbook [core 2.13.6]
python version = 3.9.16 (main, Dec  7 2022, 10:15:13) [Clang 13.0.0 (clang-1300.0.29.30)]
jinja version = 3.1.2

Si no se utiliza como kubeconfig el fichero ubicado en $HOME/.kube/config, es necesario disponer del fichero kubeconfig cargado en el directorio "files" como se describe en el apartado de variables

Variables
--------------

Las variables definidas son las siguientes:

- Nombre del fichero kubeconfig ubicado en "files" , en caso de no utilizar el .kube/config por defecto:

kubeconfig: 'aksconfig' 

- Nombre del namespace a utilizar para el despliegue
  
k8s_namespace: 'nginx'

-  En caso de utilizar un directorio que agrupe los manifiestos utilizados, se define en la siguiente variable:
  
k8s_manifest_dir: 'k8s_manifest'

- Nombre del fichero de manifiesto a utilizar, en este caso el despliegue está descrito bajo un único manifiesto:
  
manifest_file: 'nginx-pv-deployment.yaml'

Dependencias
----------------
Es necesario disponer del módulo kubernetes.core.k8s para estas operaciones con clústers de kubernetes.

Ejemplo de uso
----------------

ansible-playbook playbook-nginx-k8s-pv.yml 

Licencia
-------

BSD

Informacion del autor
------------------

OGS