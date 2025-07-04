# Proyecto-Plataformas
Descripción del proyecto:

El proyecto presentado en este repositorio se basa en un juego interctivo del tipo "Aventura de texto". En este el jugador recibe un enunciado y se le proporcionan una serie de opciones a tomar, dependiendo de cual opción elija el usuario, pasaran segun que cosas que influiran en si se pierde o se gana.
La primicia del juego se basa en el correcto manejo de situaciones respecto al kernel, por lo que el juego es educativo hasta cierto punto, en donde se premian las deciones correctas y se denotan los errores de las deciones incorrectas o poco satisfactorias.
El proyecto trabaja a nivel de kernel, a partir de un modulo de este mismo, por lo que el codigo en su totalidad utiliza funciones compatibles con el kernel, permitiendo no solo extraer datos directamente desde el kernel, sino tambien montar la interfaz con la que el usuario interactua, escaneando e imprimiendo texto, guardando variables, entre otras funciones.


Dependecias:

Referente a las dependencias para la correcta ejecución del codigo, se tienen tanto el uso de una diversa variedad de bibliotecas, como de extenciones. Todo esto tomando en cuanta el uso de Visual estudio code para la creación del codigo. 


Extensiones:

- C/C++ Extension Pack

- CMake Tools

Bibliotecas:

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/sched/signal.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/utsname.h>
#include <linux/time.h>
#include <linux/fs.h>
#include <linux/cred.h>
#include <linux/uaccess.h>
#include <linux/ktime.h>



Pasos para la instalación:


1.Descargar las versiones más actuales de los archivos "proy.c", "juego.sh" y "Makefile" directamente desde el repositorio.

2.Colocar los archivos descargados en una misma carpeta (preferiblemente en una carpeta vacia).

3.Instalar las extensiones previamente mencionadas en Visual estudio code, esto directamente desde la aplicación en la seccion de extenciones.


Pasos de construcción:


1.Se abre una nueva terminal en la maquina y se dirige a la carpeta en la que se guardaron los archivos previamente.


2.Se ejecuta el comando chmod +x juego.sh para dar perimisos de ejecución al .sh(alternativamente se puede hacer esto desde las propiedades del archivo).

3.Se ejecuta el comando "make", al ejecutarse,se deben de haber creado varios archivos nuevos en la misma carpeta (si no funciona se puede recurrir al comando "make clean", para borrar datos residuales y ejecutar el makefile).

4.Se ejecuta el comando sudo insmod proy.ko, y se introduce la contraseña del usuario.

5. Si se han cumplido los pasos anteriores de manera satisfactoria, se puede proceder con la ejecución del codigo.


Pasos para la ejecución:

1.Se crea una nueva terminal en la maquina y se dirigue a la carpeta en donde se encuentran los archivos.

2.Se ejecuta el comando "./juego.sh", el cual deberia de ejecutar el codigo de manera satisfactoria, si no es el caso ejecute el comando "sudo insmod proy.ko" y vuelva a introducir el comando "./juego.sh".

