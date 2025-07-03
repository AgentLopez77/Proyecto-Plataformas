# 🧠 Informe Técnico - Juego Interactivo "Kernel Adventure"

## Objetivos del Proyecto

* **Diseñar e Implementar un Módulo del Kernel de Linux:** Se busca un módulo del kernel que cumpla con los requerimientos y sea capaz de interactuar con un programa en la terminal con el usuario. Específicamente, el código fuente (`proy.c`) debe exponer datos reales del sistema al general un módulo "proy.ko", como procesos activos, uso de memoria RAM (total y libre) y tiempo de actividad del sistema (uptime), a través de una entrada en el sistema de archivos.

* **Desarrollar una Aplicación en Espacio de Usuario Interconectada:** Diseñar e implementar un programa en el espacio de usuario (`juego.sh`) que logre interactuar  directamente y en tiempo real con el módulo del kernel. Esta aplicación debe ser un simulador interactivo de gestión del kernel que utilice los datos expuestos por el módulo para influir en la lógica del juego y en las decisiones del usuario.

* **Documentar el Proyecto:** Generar la documentación necesaria, incluyendo un informe técnico (como este), el "readme", la documentación del repositorio y una serie de diapositivas para una presentación oral, lo anterior claro está que describa el proyecto, sus dependencias, los pasos de instalación y ejecución del código.

* **Aplicar adecuadas prácticas de desarrollo de software:** Integrar buenas prácticas en el proceso de desarrollo, lo que conlleva a integrar conocimiento del control de versiones con Git y la gestión del repositorio en GitHub mediante comandos desde la terminal así como desde la página web de Github, asegurando una adecuada organización y colaboración.




## 📘 Descripción General del Proyecto

Este proyecto consiste en un programa en lenguaje C que implementa un **Juego interactivo a partir de información del Kenel**, principalmente tomando como referencia los juegos basados en texto ó conocidos  popularmente en inglés como “Text based adventure games” pupulares en los 90's en el que el usuario mediante opciones desplegadas e ingresadas puede ir avanzando según las decisiones que tome. Sin embargo, en este caso se presentan distintos escenarios al usuario en el que se despliega la información obtenida del sistema gracias a un módulo de Kenel y el mismo usuario debe tomar la decision más acertada dentro de las opciones desplegadas, buscando claro está un correcto funcionamiento del equipo para finalmente obtener un puntaje, cabe destacar que se busca que éste juego funcione como un método interactivo de aprendizage.

Principalmente, este proyecto consiste primeramente en la creación un módulo del kernel de Linux escrito en C que crea una entrada personalizada en el sistema de archivos /proc, específicamente /proc/juego_kernel. Su propósito principal es exponer información en tiempo real del sistema operativo, como: El número total de procesos activos, la cantidad de memoria RAM total y libre, el tiempo de actividad (uptime) del sistema, PID, versión de Kenel, UID del usuario y procesos activos. Los datos anteriormente mencionados son utilizados para interactuar con el script de juego.sh que despliega distintos escenarios en los que el usuario puede tomar distintos caminos y evaluar sus conocimientos.

El proyecto está compuesto por tres archivos principales:

- `proy.c`: Código fuente.
- `Makefile`: automatiza la compilación del código fuente.
- `juego.sh`: script de automatización para compilar y ejecutar el juego.

---



### 📁 Estructura del Proyecto

```
/Proyecto-Plataformas/
├── proy.c         # Código fuente para la creación del Módulo.
├── Makefile       # Compilación automatizada
└── juego.sh       # Script interactivo del juego
```

---



## ⚙️ Componentes del Proyecto

### 🔹 1. `proy.c` - Código fuente

Crea una entrada mediante el módulo generado "proy.ko" que expone información del sistema:

- Número de procesos activos
- Memoria RAM total y libre
- Tiempo de actividad del sistema
- UID del usuario.
- Versión del kernel
- Procesos activos
- PID

Este módulo utiliza diversas funciones del kernel y permite que el juego interactúe con el sistema en tiempo real.

---

## 🧰 Librerías del Kernel Usadas en `proy.c`

| Librería               | Propósito                                                                 |
|------------------------|---------------------------------------------------------------------------|
| `linux/init.h`         | Inicialización/salida de módulos                                          |
| `linux/module.h`       | Declaración de metadatos del módulo                                       |
| `linux/proc_fs.h`      | Interacción con el sistema.                                        |
| `linux/seq_file.h`     | Escritura ordenada en archivos virtuales                              |
| `linux/mm.h`           | Información sobre uso de memoria                                          |
| `linux/sched/signal.h` | Iteración sobre procesos activos                                          |
| `linux/jiffies.h`      | Tiempo de actividad del sistema                                           |
| `linux/timekeeping.h`  | Manejo del tiempo del sistema                                             |

---

* **`linux/init.h`**: Posee código para la inicialización y salida de módulos del kernel, como `module_init()` y `module_exit()`, que definen las funciones que se ejecutan al cargar y descargar el módulo.
* **`linux/module.h`**: Totalmente necesaria para la creación de módulos del kernel. EStablece las macros para declarar metadatos del módulo, como la licencia (`MODULE_LICENSE`), el autor (`MODULE_AUTHOR`) y la descripción (`MODULE_DESCRIPTION`).
* **`linux/proc_fs.h`**: Permite interactuar con el sistema de archivos, habilitando la creación de entradas (`proc_create`) y la definición de operaciones (`proc_ops`) para que el programa del juego en este caso pueda leer información del kernel.
* **`linux/seq_file.h`**: Permite la lectura de datos del kernel de forma secuencial y paginada a través de archivos virtuales, mediante las funciones como `single_open()` y `seq_printf()`.
* **`linux/mm.h`**: Proporciona funciones y estructuras relacionadas con la gestión de memoria, como `si_meminfo()`, que permite obtener información sobre el uso de RAM (total y libre) del sistema.
* **`linux/sched/signal.h`**: Contiene definiciones para la gestión de procesos en el kernel, incluyendo la macro `for_each_process` que se utiliza para iterar sobre la lista de tareas activas.
* **`linux/jiffies.h`**: Define `jiffies`, una variable global que cuenta los "ticks" del temporizador del sistema, y `HZ`, que representa los jiffies por segundo. Es esencial para calcular el tiempo de actividad (uptime) del sistema.
* **`linux/timekeeping.h`**: Proporciona funciones y estructuras más generales para la gestión del tiempo y la sincronización dentro del kernel.






### 🔹 2. `Makefile` - Automatización de Compilación

La implementacion de un makefile en el proyecto nace de la necesidad de la inclusion de un modulo de kernel para el correcto acceso y manejo de los datos de este, por lo que atraves del contenido del makefile y a partir del archivo proy.o se crean diversos archivos, principalmente el archivo .ko que es el encargado del modulo del kernel.

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

El archivo `juego.sh` es un script de shell de Bash que implementa un simulador interactivo/educativo de gestión del kernel de Linux. Este juego interactúa directamente con un módulo del kernel personalizado creado gracias al código fuente, leyendo datos reales del sistema (como procesos activos, RAM y tiempo de actividad) a través de una entrada especial en `/proc/juego_kernel`. El objetivo del juego es que el usuario tome decisiones como un administrador del núcleo para mantener la estabilidad, seguridad y rendimiento del sistema, afectando un puntaje y un contador de fallos.

Simula un sistema que reacciona a decisiones administrativas del jugador basadas en datos reales del sistema.

#### 🔑 Variables Iniciales

Como primer paso el script define dos variables clave al inicio para llevar el seguimiento del progreso del jugador:

- `Reputación = 50`
- `fallos = 0`

* `Reputación`: Inicializado en `50`, representa la puntuación actual del jugador. Las decisiones correctas aumentan el puntaje de 10 en 10 cada acierto, mientras que las incorrectas lo disminuyen.
* `fallos`: Inicializado en `0`, cuenta el número de errores críticos o fallos que el jugador ha cometido durante el juego.



#### 🧩 Funciones Clave

El script utiliza varias funciones para modular su comportamiento y mejorar la legibilidad:

* **`cargar_datos_kernel()`**
    * **Propósito:** Esta función es primordial, ya que es la encargada de leer los datos del sistema desde el módulo del kernel. Accede al archivo `/proc/juego_kernel` y extrae valores como el número de procesos activos, la RAM total, la RAM libre, y el tiempo de actividad del sistema entre otros.
    * **Implementación:** Hace uso de comandos de shell (`cat`, `grep`, `awk`) para parsear la salida del módulo del kernel y asignar los valores a variables específicas del script (`procesos`, `ram_total`, `ram_libre`, `uptime`).

* **`nota()`**
    * **Propósito:** Muestra una "nota técnica" al usuario después de ciertas decisiones en el juego. Estas notas ofrecen explicaciones o principios relacionados con la gestión del kernel, añadiendo un componente educativo al simulador.
    * **Implementación:** Imprime un mensaje en color cian utilizando códigos de escape ANSI.

* **`pausa()`**
    * **Propósito:** Pausa la ejecución del script y espera la entrada del usuario (`Enter`) antes de continuar. También limpia la pantalla para una mejor experiencia visual.

#### 🎮 Estructura del Juego

El juego se desarrolla a través de una serie de "escenas", cada una presentando un escenario de gestión del sistema y solicitando una decisión al usuario, cada escena presenta un escenario y decisiones.

* **Pantalla de Bienvenida:** Muestra un título y una introducción al juego, explicando el rol del jugador como "el núcleo del sistema Linux", además solicita que el usuario ingrese su nombre.
* **ESCENA 1: Gestión del Sistema**
    * **Escenario:** Se le muestra al usuario la carga promedio y los procesos activos.
    * **Decisión correcta:** Reducir tareas pesadas y priorizar servicios críticos.
    * **Interacción con Kernel:** Carga datos reales del kernel de los procesos activos en el equipo.
* **ESCENA 2: Apertura de un navegador**
    * **Escenario:** Conociendo la memoria RAM libre, el usuario desea abrir un navegador con múltiples ventanas.
    * **Decisión:** Limitar recursos y liberar memoria, ignorar el uso de RAM ó abrir permitir la ejecución pero limitar la cantidad de pestañas.
    * **Interacción con Kernel:** Carga datos reales de la memoria RAM disponible en el equipo.
* **ESCENA 3: Logs acumulados**
    * **Escenario:** Un usuario conoce el tiempo que el equipo ha estado encendido, y sabe que hay muchos logs acumulados.
    * **Decisión:** Planificar la limpieza y reinicio controlado, ignorar la limpieza y no detener ningún servico ó reiniciar forzosamente.
    * **Interacción con Kernel:** Carga el uptime ó tiempo en que el equipo lleva encendido.
* **ESCENA 4: Comportamiento anómalo**
    * **Escenario:** Se conoce el PID actual, así como en PID padre y se sospecha un comportamiento anómalo en el sistema
    * **Decisión:** Auditar el proceso actual y validar los logs, matar el proceso ó esperar a que finalice el proceso.
    * **Interacción con Kernel:** Extrae y muestra el PID actual y padre.
* **ESCENA 5: Versión de Kernel**
    * **Escenario:** Existe una nueva versión de Kernel que puede solucionar bugs críticos. 
    * **Decisión:** Probarlo en un entorno de prueba antes de actualizar, actualizar directamente ó decidir mantener la versión actual.
    * **Interacción con Kernel:** Muestra la versión actual del Kernel en uso.
* **ESCENA 6: Sevicios lentos**
    * **Escenario:** Debido a los procesos actuales y una subida en la carga, existen servicios lentos.
    * **Decisión:** Priorizar servicios claves y pausar tareas no críticas, reiniciar servicios sin aviso al usuario ó aumentar hilos sin gestionar la GPU.
    * **Interacción con Kernel:** Carga datos reales del kernel de los procesos activos en el equipo y la carga.
* **ESCENA 7: Múltiples Scripts**
    * **Escenario:** Un usuario ejecuta múltiples Scripts pesados al mismo tiempo.
    * **Decisión:** Se le asignan límites con cgroups y se notifica al usuario, se bloquea la cuenta al usuario ó no se interviene en la ejecución de los scripts.
    * **Interacción con Kernel:** Carga el UID del usuario.
* **ESCENA 8: Otro servicio planea iniciar**
    * **Escenario:** Conociendo la memoria RAM libre, se debe decidir que hacer en caso de que un nuevo servicio se planea comenzar
    * **Decisión:** Se suspende el inicio hasta liberar memoria, se fuerza el arranque ignorando el riesgo ó se asigna un Swap temporal antes de comenzar.
    * **Interacción con Kernel:** Carga datos reales de la memoria RAM disponible en el equipo.
* **ESCENA 9: Varios procesos no responden**
    * **Escenario:** Conociendo el uptime y la carga se sabe que existen varios procesos que no responden.
    * **Decisión:** Se ejecuta un monitoreo y se configuran prioridades, se reincia el sistema sin guardar estado ó se espera más tiempo sin actuar
    * **Interacción con Kernel:** Carga el uptime ó tiempo en que el equipo lleva encendido y la carga.
* **ESCENA 10: Ejecución de análisis**
    * **Escenario:** Conociendo la cantidad de procesos activos se recibe una solicitud para ejecutar un análisis profundo del sistema.
    * **Decisión:** Se programa un análisis en horas de baja carga, se ejecuta de inmediato con la posibilidad de generar lentitud ó se rechaza el análisis.
    * **Interacción con Kernel:** Carga datos reales del kernel de los procesos activos en el equipo y la carga.







#### 🔑 Interacción con el Módulo del Kernel (`proy.c`)

La característica distintiva de `juego.sh` es su capacidad para interactuar con el módulo del kernel `proy.ko` creado por `proy.c`. Esto se logra mediante la lectura del archivo `/proc/juego_kernel` creado por el módulo.

* El módulo es responsable de compilar y exponer datos del sistema operativo (número de procesos, uso de RAM, tiempo de actividad) a través de este archivo virtual.
* El script `juego.sh` llama a la función `cargar_datos_kernel()` para leer estos datos en momentos clave del juego, lo que permite que las decisiones y escenarios se basen en información "real" del sistema (simulada por el módulo).



#### 📊 Final del Juego

Al final de todas las escenas, el juego muestra un mensaje dependiendo del puntaje final del jugador:


* **Mensaje final:** Basado en el puntaje y los fallos, se muestra un mensaje de felicitación por una buena gestión o una recomendación para repasar conceptos del kernel.

El juego concluye reiterando que todos los datos mostrados provienen directamente de un módulo del kernel cargado en tiempo real.



## 💻 Requisitos del Sistema

- `gcc` (Compilador C)
- `make`
- Terminal compatible con Bash (Linux, WSL o macOS)

---


## ✅ Conclusiones del Proyecto

* **Integración Exitosa Kernel-Userspace:** El proyecto ha demostrado una integración exitosa entre un módulo del kernel de Linux y un script en espacio de usuario. El módulo creado por (`proy.c`) cumple su función de exponer datos del sistema, y el juego (`juego.sh`) los consume eficazmente para crear una experiencia interactiva.

* **Funcionalidad y Relevancia Técnica:** La funcionalidad implementada de reportar métricas del sistema (procesos, RAM, uptime...) a través de `/proc` es directamente relevante para la supervisión y gestión del sistema operativo, mostrando una aplicación práctica del desarrollo de módulos del kernel.

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

