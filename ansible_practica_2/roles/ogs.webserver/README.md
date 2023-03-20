Despliegue de webserver sobre podman en máquina virtual
=========

El objetivo del rol es instalar podman en una máquina virtual, levantando un servidor web, utilizando una imágen albergada en el Azure Container Registry del grupo de recursos.

Requisitos
------------

Para el despliegue se han utilizado las siguientes versiones: 
ansible-playbook [core 2.13.6]
python version = 3.9.16 (main, Dec  7 2022, 10:15:13) [Clang 13.0.0 (clang-1300.0.29.30)]
jinja version = 3.1.2

Fichero hosts con el siguiente contenido:
[web-servers]
<ips de aquellas máquinas virtuales donde se instalará>

Obtener las credenciales utilizadas del Azure Container Registry donde se encuentra la imagen a utilizar, para ello:
az acr update -n <nombre ACR> --admin-enabled true
az acr credential show --name <nombre ACR>


Variables
--------------

Las variables a tener en cuenta, se encuentran en propio fichero de la tarea "install_webserver.yml" ,acerca de la imagen a utilizar, nombre, y las credenciales contra el ACR utilizado (visto en el apartado "Requisitos").

Dependencias
------------

Se utiliza el módulo containers.podman.podman_image

Ejemplo de uso
----------------

ansible-playbook playbook-nginx-podman.yml

Licencia
-------

BSD

Autor
------------------

OGS
