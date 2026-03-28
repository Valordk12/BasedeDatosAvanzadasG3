# Documentacion de Comandos de Contenedores de SGBD

## Contenedores sin Volumen
**Comando para creacion de contenedor con nombre de Imagen**
```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1438:1433 --name servidorsqlserverDev \
   -d \
   mcr.microsoft.com/mssql/server:2019-latest
```

**Comando para creacion de contenedor con id**
```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1438:1433 --name servidorsqlserverDev \
   -d \
   db9a
```
## Contenedores con Volumen

```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
   -p 1439:1433 --name servidorsqlserverDev2 -v volume-sqlserverDev:/var/opt/mssql/ \
   -d \
   db9a
```


/var/opt/mssql/data/

