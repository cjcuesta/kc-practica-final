# K8s

<a name="top"></a>
## Forma de funcionamiento

Para la práctica se utilizó **Minikube** y se ejecutaron los siguientes comandos. 

```
minikube start 
```

```
minikube addons enable metrics-server
```
![](imagenes/ActivacionMinikubeMetric-Server.png)
```
minikube addons enable ingress
```
![](imagenes/ActivacionMinikubeIngress.png)
```
minikube tunnel 
```
![](imagenes/ActivacionMinikubeTunnel.png)

Para el último comando se debe digitar el password de root y este bloqueará la consola donde se ejecute. 

Podemos visualizar la activación de los addOns de Minikube
```
minikube addons list | grep -i enabled 
```
![](imagenes/MinikubeEnabled.png)



## Instalacion de los manifiestos. 

Para iniciar se debe bajar la carpeta K8s donde se encuntran todos los maninifiestos. 

### Instalación de los manifiestos
```

k apply -f cm-init-mysql.yaml

k apply -f pv-mysql.yaml 

k apply -f mysql-service.yaml

k apply -f mysql-deployment.yaml

k exec -ti mysql-b74bd6b99-nvwq2 -- bash

mysql -u dev -pdev

show databases;

use crud_flask;

show tables; 

k apply -f flask-app-service.yaml

k apply -f flask-app-deployment.yaml 



```


[Volver al principio](#top)
[Volver a README principal](../README.md)