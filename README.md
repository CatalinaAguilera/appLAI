# appLAI
Pruebas al cargar la imagen, utilizando solo un raster.
Eliminando altiro con remove() y gc() para liberar memoria.
Se probo utilizar una lista y no valores reactivos, pero tampoco funciono.
tambien probe disminuir aun mas la resolucion (18) pero tampoco funciono.
en connect.R intente asignar mas espacio en shiny, pero no esta permitido para cuentas gratuitas.
he revisado en el server shiny y he aumentado las variables que este permite, pero aun así se cae.
tambien se uso la libreria pryr, funcion mem_used para ver los mb que utiliza la aplicacion solo al iniciar (500mb aprox) print(mem_used)
