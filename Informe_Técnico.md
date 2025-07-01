# 🧠 Informe Técnico - Juego de Adivinanza en C

## 📘 Descripción General del Proyecto

Este proyecto consiste en un programa en lenguaje C que implementa un **juego interactivo de adivinanza numérica**, principalmente tomando como referencia los juegos basados en texto ó conocidos  popularmente en inglés como “Text based adventure games” pupulares en los 90's en el que el usuario mediante opciones desplegadas e ingresadas puede ir avanzando. 

En éste caso este proyecto consiste primeramente en en un módulo del kernel de Linux escrito en C que crea una entrada personalizada en el sistema de archivos /proc, específicamente /proc/juego_kernel. Su propósito principal es exponer información en tiempo real del sistema operativo, como: El número total de procesos activos, la cantidad de memoria RAM total y libre y el tiempo de actividad (uptime) del sistema, datos que son utilizados para interactuar con el script de juego.sh que despliega distintos escenarios en los que el usuario puede tomar distintos caminos y evaluar sus conocimientos.

El proyecto está compuesto por tres archivos principales:

- `proy.c`: Módulo del kernel en C.
- `Makefile`: automatiza la compilación del código fuente.
- `juego.sh`: script de automatización para compilar y ejecutar el juego.

---

## Objetivos del Proyecto

* **Diseñar e Implementar un Módulo del Kernel de Linux:** Crear un módulo del kernel que funcione correctamente y sea capaz de interactuar con un programa en el espacio de usuario. Específicamente, el módulo (`proy.c`) debe exponer datos reales del sistema, como procesos activos, uso de memoria RAM (total y libre) y tiempo de actividad del sistema (uptime), a través de una entrada en el sistema de archivos `/proc` (`/proc/juego_kernel`).

* **Desarrollar una Aplicación en Espacio de Usuario Interconectada:** Implementar un programa en el espacio de usuario (`juego.sh`) que interactúe directamente con el módulo del kernel. Esta aplicación debe ser un simulador interactivo de gestión del kernel que utilice los datos expuestos por el módulo para influir en la lógica del juego y en las decisiones del usuario.

* **Documentar el Proyecto Exhaustivamente:** Generar la documentación necesaria, incluyendo un informe técnico (como este) y la documentación del repositorio, que describa el proyecto, sus dependencias, los pasos de instalación y ejecución del código.

* **Aplicar Buenas Prácticas de Desarrollo de Software:** Integrar buenas prácticas en el proceso de desarrollo, lo que incluye el uso de control de versiones con Git y la gestión del repositorio en GitHub, asegurando una adecuada organización y colaboración.

### 📁 Estructura del Proyecto

```
/Proyecto-Plataformas/
├── proy.c         # Módulo del kernel en C
├── Makefile       # Compilación automatizada
└── juego.sh       # Script interactivo del juego
```

---



## ⚙️ Componentes del Proyecto

### 🔹 1. `proy.c` - Módulo del Kernel

Crea una entrada en `/proc/juego_kernel` que expone información del sistema:

- Número de procesos activos
- Memoria RAM total y libre
- Tiempo de actividad del sistema

Este módulo utiliza diversas funciones del kernel y permite que el juego interactúe con el sistema en tiempo real.

---

## 🧰 Librerías del Kernel Usadas en `proy.c`

| Librería               | Propósito                                                                 |
|------------------------|---------------------------------------------------------------------------|
| `linux/init.h`         | Inicialización/salida de módulos                                          |
| `linux/module.h`       | Declaración de metadatos del módulo                                       |
| `linux/proc_fs.h`      | Interacción con el sistema `/proc`                                        |
| `linux/seq_file.h`     | Escritura estructurada en archivos virtuales                              |
| `linux/mm.h`           | Información sobre uso de memoria                                          |
| `linux/sched/signal.h` | Iteración sobre procesos activos                                          |
| `linux/jiffies.h`      | Tiempo de actividad del sistema                                           |
| `linux/timekeeping.h`  | Manejo del tiempo del sistema                                             |

---

* **`linux/init.h`**: Contiene macros para la inicialización y salida de módulos del kernel, como `module_init()` y `module_exit()`, que definen las funciones que se ejecutan al cargar y descargar el módulo.
* **`linux/module.h`**: Es fundamental para la creación de módulos del kernel. Define las macros para declarar metadatos del módulo, como la licencia (`MODULE_LICENSE`), el autor (`MODULE_AUTHOR`) y la descripción (`MODULE_DESCRIPTION`).
* **`linux/proc_fs.h`**: Permite interactuar con el sistema de archivos `/proc`, habilitando la creación de entradas (`proc_create`) y la definición de operaciones (`proc_ops`) para que los programas de usuario puedan leer información del kernel.
* **`linux/seq_file.h`**: Facilita la lectura de datos del kernel de forma secuencial y paginada a través de archivos virtuales como los de `/proc`, utilizando funciones como `single_open()` y `seq_printf()`.
* **`linux/mm.h`**: Proporciona funciones y estructuras relacionadas con la gestión de memoria, como `si_meminfo()`, que permite obtener información sobre el uso de RAM (total y libre) del sistema.
* **`linux/sched/signal.h`**: Contiene definiciones para la gestión de procesos en el kernel, incluyendo la macro `for_each_process` que se utiliza para iterar sobre la lista de tareas activas.
* **`linux/jiffies.h`**: Define `jiffies`, una variable global que cuenta los "ticks" del temporizador del sistema, y `HZ`, que representa los jiffies por segundo. Es esencial para calcular el tiempo de actividad (uptime) del sistema.
* **`linux/timekeeping.h`**: Proporciona funciones y estructuras más generales para la gestión del tiempo y la sincronización dentro del kernel.






### 🔹 2. `Makefile` - Automatización de Compilación

Permite compilar fácilmente el módulo con `make`. Comando principal:

```bash
make
```

Ejecuta:

```makefile
gcc -o juego proy.c
```

Genera el ejecutable `juego`.

#### 🔍 Estructura del Makefile

```makefile
CC = gcc
CFLAGS = -Wall -Wextra -g
SRC = main.c parser.c utils.c
OBJ = $(SRC:.c=.o)
TARGET = programa

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
```

---

### 🔹 3. `juego.sh` - Juego Interactivo

El archivo `juego.sh` es un script de shell de Bash que implementa un simulador interactivo de gestión del kernel de Linux. Este juego interactúa directamente con un módulo del kernel personalizado (`proy.c`), leyendo datos reales del sistema (como procesos activos, RAM y tiempo de actividad) a través de una entrada especial en `/proc/juego_kernel`. El objetivo del juego es que el usuario tome decisiones como un administrador del núcleo para mantener la estabilidad, seguridad y rendimiento del sistema, afectando un puntaje y un contador de fallos.

Simula un sistema que reacciona a decisiones administrativas del jugador basadas en datos reales del sistema.

#### 🔑 Variables Iniciales

El script define dos variables clave al inicio para llevar el seguimiento del progreso del jugador:

- `puntaje = 100`
- `fallos = 0`

* `puntaje`: Inicializado en `100`, representa la puntuación actual del jugador. Las decisiones correctas aumentan el puntaje, mientras que las incorrectas lo disminuyen.
* `fallos`: Inicializado en `0`, cuenta el número de errores críticos o fallos que el jugador ha cometido durante el juego.



#### 🧩 Funciones Clave

El script utiliza varias funciones para modular su comportamiento y mejorar la legibilidad:

* **`cargar_datos_kernel()`**
    * **Propósito:** Esta función es la encargada de leer los datos del sistema desde el módulo del kernel. Accede al archivo `/proc/juego_kernel` y extrae valores como el número de procesos activos, la RAM total, la RAM libre y el tiempo de actividad del sistema.
    * **Implementación:** Utiliza comandos de shell (`cat`, `grep`, `awk`) para parsear la salida del módulo del kernel y asignar los valores a variables específicas del script (`procesos`, `ram_total`, `ram_libre`, `uptime`).

* **`nota()`**
    * **Propósito:** Muestra una "nota técnica" al usuario después de ciertas decisiones en el juego. Estas notas ofrecen explicaciones o principios relacionados con la gestión del kernel, añadiendo un componente educativo al simulador.
    * **Implementación:** Imprime un mensaje en color cian utilizando códigos de escape ANSI.

* **`pausa()`**
    * **Propósito:** Pausa la ejecución del script y espera la entrada del usuario (`Enter`) antes de continuar. También limpia la pantalla para una mejor experiencia visual.

#### 🎮 Estructura del Juego

El juego se desarrolla a través de una serie de "escenas", cada una presentando un escenario de gestión del sistema y solicitando una decisión al usuario.

Cada escena presenta un escenario y decisiones como:

1. **Inicio del sistema**
2. **Uso excesivo de CPU**
3. **Intento de intrusión**
4. **Análisis de uptime**
5. **Posible kernel panic**


* **Pantalla de Bienvenida:** Muestra un título y una introducción al juego, explicando el rol del jugador como "el núcleo del sistema Linux".
* **ESCENA 1: El Sistema Despierta**
    * **Escenario:** El sistema se inicia después de un apagón inesperado.
    * **Decisión:** Revisar el estado de la memoria RAM o los procesos activos.
    * **Interacción con Kernel:** Carga datos reales del kernel para informar la decisión y las consecuencias.
* **ESCENA 2: CPU al Límite**
    * **Escenario:** Un proceso desconocido consume la mayor parte de la CPU.
    * **Decisión:** Matar el proceso, cambiar la política de planificación o ignorar.
* **ESCENA 3: Intrusión Sospechosa**
    * **Escenario:** Un usuario intenta escalar privilegios.
    * **Decisión:** Revocar permisos temporalmente o permitir el acceso.
* **ESCENA 4: Tiempo de Actividad**
    * **Escenario:** Se analiza la estabilidad del sistema basándose en su tiempo de actividad.
    * **Decisión:** Reiniciar el sistema suavemente o no.
    * **Interacción con Kernel:** Muestra el tiempo de actividad real obtenido del kernel.
* **ESCENA 5: Posible Kernel Panic**
    * **Escenario:** Un driver falla al acceder a memoria inválida.
    * **Decisión:** Aislar el driver fallido o reiniciar el subsistema.


#### 🔑 Interacción con el Módulo del Kernel (`proy.c`)

La característica distintiva de `juego.sh` es su capacidad para interactuar con el módulo del kernel `proy.c`. Esto se logra mediante la lectura del archivo `/proc/juego_kernel` creado por el módulo.

* El módulo `proy.c` es responsable de compilar y exponer datos del sistema operativo (número de procesos, uso de RAM, tiempo de actividad) a través de este archivo virtual.
* El script `juego.sh` llama a la función `cargar_datos_kernel()` para leer estos datos en momentos clave del juego, lo que permite que las decisiones y escenarios se basen en información "real" del sistema (simulada por el módulo).



#### 📊 Final del Juego

Al final de todas las escenas, el juego muestra un resumen de las estadísticas del jugador:

* **Puntaje final:** El puntaje acumulado a lo largo del juego.
* **Fallos cometidos:** El número total de errores críticos.
* **Mensaje final:** Basado en el puntaje y los fallos, se muestra un mensaje de felicitación por una buena gestión o una recomendación para repasar conceptos del kernel.

El juego concluye reiterando que todos los datos mostrados provienen directamente de un módulo del kernel cargado en tiempo real.



## 💻 Requisitos del Sistema

- `gcc` (Compilador C)
- `make`
- Terminal compatible con Bash (Linux, WSL o macOS)

---


## ✅ Conclusiones del Proyecto

* **Integración Exitosa Kernel-Userspace:** El proyecto ha demostrado una integración exitosa entre un módulo del kernel de Linux y un script en espacio de usuario. El módulo (`proy.c`) cumple su función de exponer datos del sistema, y el juego (`juego.sh`) los consume eficazmente para crear una experiencia interactiva.

* **Funcionalidad y Relevancia Técnica:** La funcionalidad implementada de reportar métricas del sistema (procesos, RAM, uptime) a través de `/proc` es directamente relevante para la supervisión y gestión del sistema operativo, mostrando una aplicación práctica del desarrollo de módulos del kernel.

* **Experiencia Educativa Interactiva:** El juego en Bash ofrece un enfoque interactivo y didáctico para comprender el impacto de las decisiones a nivel del kernel. La utilización de datos "reales" del sistema (proporcionados por el módulo) en el juego mejora la inmersión y la relevancia de las simulaciones.

* **Adquisición de Habilidades de Desarrollo:** El proyecto requirió la habilidad de escribir código seguro y eficiente en C para el kernel, así como scripting en Bash para la lógica del juego. Además, subraya la importancia del trabajo en equipo y la documentación como aspectos críticos en proyectos de software.

* **Cumplimiento de Requisitos del Curso:** El proyecto satisface los requisitos fundamentales de diseño, implementación y documentación de un módulo del kernel que interactúa con un programa de userspace, aplicando buenas prácticas de desarrollo y gestión de repositorios.

## Referencias

* **The Linux Kernel Module Programming Guide (LKMPG):** Guía fundamental para entender cómo escribir módulos para el kernel de Linux. Proporciona una base sólida sobre la estructura, funciones y mejores prácticas para el desarrollo de código a nivel de kernel.
    * [https://sysprog21.github.io/lkmpg/](https://sysprog21.github.io/lkmpg/)

* **Documentación Oficial del Kernel de Linux:** Recursos exhaustivos que cubren las APIs, estructuras de datos y funcionalidades internas del kernel, esenciales para el desarrollo de módulos y la comprensión de sus interacciones con el sistema.
    * (Referencia genérica: Se recomendaría buscar la documentación específica de las versiones de kernel utilizadas o los subsistemas relevantes en [kernel.org](https://www.kernel.org/doc/html/latest/))

* **Manual de Referencia de Bash:** Documentación detallada sobre el shell Bash, sus comandos, sintaxis y características, indispensable para la creación de scripts como `juego.sh` que interactúan con el sistema y procesan la salida de otros programas.
    * (Referencia genérica: Se recomendaría buscar manuales oficiales de Bash o guías completas como la "Bash Reference Manual" disponible en línea, por ejemplo, en [gnu.org](https://www.gnu.org/software/bash/manual/bash.html))

