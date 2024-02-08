<a name="top"></a>
# Agenda Digital DevOps4All



## Descripción de la solución
* Se tiene una aplicación Web hecha en Python con Flask. 
* Se tiene una base de datos MySQL. 
* La App realiza operaciones de inserción y consulta sobre la base de datos.

Dicha App es una copia modificada de la aplicación encontrada
el repositorio público [Simple CRUD](https://github.com/muhammadhanif/crud-application-using-flask-and-mysql) 

![](imagenes/1.png)

## Funcionamiento
### Página de inicio
![](imagenes/app_pantalla_inicial.png)
### Ingeso de Registro
![](imagenes/app_Add_Phone_Number.png)
### Registro Realizado
![](imagenes/app_nuevo_registro.png)
## Requisitos
* Tener Docker instalado
* Tener Docker-Compose instalado
* Tener Kubectl instalado
* Tener Minikube instalado
* Tener Helm instalado

## Despligue
* Para funcionamiento local en Docker: [Docker: App + MySQL](./Docker/Docker.md)
* Para funcionamiento con manifiestos YAML: [K8s: App + MySQL](./k8s/K8s.md)
* Para funcionamiento con Helm Chart: [Helm: App + MySQL](./Helm/Helm.md)
* Para funcionamiento con Terraform: [Terraform: App + MySQL](./Terraform/Terraform.md)
