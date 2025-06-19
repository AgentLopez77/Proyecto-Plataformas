# Informe Técnico - Juego de Adivinanza en C

## 📄 Descripción del Proyecto

Este proyecto consiste en un programa en lenguaje C que implementa un **juego interactivo de adivinanza numérica**, principalmente tomando como referencia los juegos basados en texto ó cocido  popularmente en inglés como “Text based adventure games” pupulares en los 90's en el que el usuario mediante opciones desplegadas e ingresadas puede ir avanzando. 

En este caso se adaptó de tal forma que el objetivo del juego es que el usuario adivine un número aleatorio generado por el programa, que se encuentra en el rango de **1 a 100** utilizando un módulo de kernel que extrae información del sistema para que forme parte de la compilación del juego.

El proyecto está compuesto por tres archivos principales:

- `proy.c`: código fuente en C del juego.
- `Makefile`: automatiza la compilación del código fuente.
- `juego.sh`: script de automatización para compilar y ejecutar el juego.

---

## 📂 Estructura de Archivos dentro de la carpeta destinada al proyecto.

/Proyecto-Plataformas/
├── proy.c
├── Makefile
└── juego.sh

## ⚙️ Descripción de los Archivos

### 1. `proy.c`

- Es el **código fuente del juego**, escrito en C.
- El programa realiza las siguientes funciones:
  - Inicializa el generador de números aleatorios usando `srand(time(NULL))`.
  - Genera un número secreto entre 1 y 100:
  
    ```c
    numero_secreto = rand() % 100 + 1;
    ```

  - Lee el intento del usuario mediante `scanf`.
  - Informa al usuario si su intento es mayor o menor que el número secreto.
  - Cuenta la cantidad de intentos realizados.
  - Finaliza el juego cuando el usuario adivina correctamente, mostrando un mensaje de felicitación y la cantidad de intentos.

---

### 2. `Makefile`

- Automatiza la compilación del programa con la herramienta `make`.
- Permite compilar el programa con un simple comando:

    ```bash
    make
    ```

- El comando de compilación es:

    ```makefile
    gcc -o juego proy.c
    ```

- El resultado es un ejecutable llamado `juego`.

---

### 3. `juego.sh`

- Script de shell que automatiza el proceso completo de:
    - Limpiar la terminal.
    - Compilar el programa.
    - Ejecutar el juego.

- Contenido:

    ```bash
    #!/bin/bash
    clear
    echo "Compilando el programa..."
    make
    echo "Ejecutando el juego..."
    ./juego
    ```

- Instrucciones de uso:

    1. Dar permisos de ejecución al script:

        ```bash
        chmod +x juego.sh
        ```

    2. Ejecutarlo:

        ```bash
        ./juego.sh
        ```

---

## 📋 Requisitos del Sistema

- **Compilador de C**: `gcc`
- **Herramienta Make**: `make`
- **Terminal compatible**: bash (Linux, WSL, macOS)


## ✅ Conclusiones

Este proyecto es un ejemplo básico de cómo:

- Desarrollar un pequeño programa en C.
- Usar un `Makefile` para automatizar la compilación.
- Usar un script de shell para automatizar la compilación y ejecución.

El proyecto resulta ideal para quienes inician en el desarrollo en C, automatización de proyectos con `make` y uso de scripts en entorno Linux.

