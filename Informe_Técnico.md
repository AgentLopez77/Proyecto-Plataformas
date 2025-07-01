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

El programa .c `proy.c` es un módulo del kernel de Linux que fue creado de tal forma que exponga datos del sistema al un juego interactivo. En principio genera una entrada en el sistema de archivos `/proc` llamada `juego_kernel`. Una vez que se lee desde esta entrada, el programa arroja información referente del estado del sistema, incluyendo el número de procesos activos, la memoria RAM total y libre, y el tiempo de actividad del sistema.
---

### 2. `Makefile`

- #### ⚙️ Funcionamiento general

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



1. Al ejecutar `make`, se compilan los archivos `.c` si han cambiado.
2. Luego se enlazan los archivos `.o` para generar el ejecutable `programa`.
3. Con `make clean`, se eliminan los binarios para recompilar desde cero.

- #### 🔍 Explicación de cada sección

##### 1. **Variables**
- `CC = gcc`: Define el compilador a usar (`gcc`, compilador de C).
- `CFLAGS = -Wall -Wextra -g`: Opciones del compilador:
  - `-Wall`: Activa todas las advertencias comunes.
  - `-Wextra`: Activa advertencias adicionales.
  - `-g`: Incluye información de depuración.
- `SRC = main.c parser.c utils.c`: Archivos fuente del proyecto.
- `OBJ = $(SRC:.c=.o)`: Archivos objeto generados a partir de los `.c`.
- `TARGET = programa`: Nombre del ejecutable final.

##### 2. **Regla principal (`all`)**
```makefile
all: $(TARGET)
```
- Esta es la regla por defecto. Compila todo el proyecto generando el ejecutable `programa`.

##### 3. **Regla para crear el ejecutable**
```makefile
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^
```
- Crea el ejecutable a partir de los archivos `.o`.
- `$@`: Se refiere al nombre del objetivo (en este caso `programa`).
- `$^`: Lista de dependencias (todos los `.o`).

##### 4. **Regla de compilación de cada archivo `.c`**
```makefile
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
```
- Compila cada archivo fuente `.c` a su correspondiente archivo objeto `.o`.
- `$<`: Primera dependencia (archivo `.c`).
- `$@`: Archivo objetivo (`.o`).

##### 5. **Regla `clean`**
```makefile
clean:
	rm -f $(OBJ) $(TARGET)
```
- Elimina archivos objeto y el ejecutable.
- Se usa para limpiar el directorio del proyecto.





### 3. `juego.sh`

#### 1. Resumen del Programa

- El archivo juego.sh es un script de shell de Bash que implementa un simulador interactivo de gestión del kernel de Linux. Este juego interactúa directamente con un módulo del kernel personalizado (proy.c), leyendo datos reales del sistema (como procesos activos, RAM y tiempo de actividad) a través de una entrada especial en /proc/juego_kernel. 
El objetivo del juego es que el usuario tome decisiones como un administrador del núcleo para mantener la estabilidad, seguridad y rendimiento del sistema, afectando un puntaje y un contador de fallos.

#### 2. Variables Iniciales

El script define dos variables clave al inicio para llevar el seguimiento del progreso del jugador:

* `puntaje`: Inicializado en `100`, representa la puntuación actual del jugador. Las decisiones correctas aumentan el puntaje, mientras que las incorrectas lo disminuyen.
* `fallos`: Inicializado en `0`, cuenta el número de errores críticos o fallos que el jugador ha cometido durante el juego.

#### 3. Funciones Clave

El script utiliza varias funciones para modular su comportamiento y mejorar la legibilidad:

* **`cargar_datos_kernel()`**
    * **Propósito:** Esta función es la encargada de leer los datos del sistema desde el módulo del kernel. Accede al archivo `/proc/juego_kernel` y extrae valores como el número de procesos activos, la RAM total, la RAM libre y el tiempo de actividad del sistema.
    * **Implementación:** Utiliza comandos de shell (`cat`, `grep`, `awk`) para parsear la salida del módulo del kernel y asignar los valores a variables específicas del script (`procesos`, `ram_total`, `ram_libre`, `uptime`).

* **`nota()`**
    * **Propósito:** Muestra una "nota técnica" al usuario después de ciertas decisiones en el juego. Estas notas ofrecen explicaciones o principios relacionados con la gestión del kernel, añadiendo un componente educativo al simulador.
    * **Implementación:** Imprime un mensaje en color cian utilizando códigos de escape ANSI.

* **`pausa()`**
    * **Propósito:** Pausa la ejecución del script y espera la entrada del usuario (`Enter`) antes de continuar. También limpia la pantalla para una mejor experiencia visual.
    * **Implementación:** Utiliza `read -p` para la pausa y `clear` para limpiar la terminal.


#### 4. Estructura del Juego (Escenas)

El juego se desarrolla a través de una serie de "escenas", cada una presentando un escenario de gestión del sistema y solicitando una decisión al usuario.

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

#### 5. Interacción con el Módulo del Kernel (`proy.c`)

La característica distintiva de `juego.sh` es su capacidad para interactuar con el módulo del kernel `proy.c`. Esto se logra mediante la lectura del archivo `/proc/juego_kernel` creado por el módulo.

* El módulo `proy.c` es responsable de compilar y exponer datos del sistema operativo (número de procesos, uso de RAM, tiempo de actividad) a través de este archivo virtual.
* El script `juego.sh` llama a la función `cargar_datos_kernel()` para leer estos datos en momentos clave del juego, lo que permite que las decisiones y escenarios se basen en información "real" del sistema (simulada por el módulo).

#### 6. Final del Juego y Estadísticas

Al final de todas las escenas, el juego muestra un resumen de las estadísticas del jugador:

* **Puntaje final:** El puntaje acumulado a lo largo del juego.
* **Fallos cometidos:** El número total de errores críticos.
* **Mensaje final:** Basado en el puntaje y los fallos, se muestra un mensaje de felicitación por una buena gestión o una recomendación para repasar conceptos del kernel.

El juego concluye reiterando que todos los datos mostrados provienen directamente de un módulo del kernel cargado en tiempo real.




## Descripción de las librerías utilizadas.

### `linux/init.h`

* **Propósito:** Este archivo de cabecera define macros para la inicialización y salida de módulos del kernel. Las macros clave son `module_init()` y `module_exit()`, que especifican las funciones a ejecutar cuando el módulo se carga y descarga, respectivamente. También incluye macros como `__init` y `__exit` que optimizan la ubicación del código en memoria.
* **Uso en `proy.c`:** En el programa, `module_init(iniciar_modulo)` y `module_exit(salir_modulo)` registran las funciones `iniciar_modulo` y `salir_modulo` como los puntos de entrada y salida del módulo.

### `linux/module.h`

* **Propósito:** Es el archivo de cabecera fundamental para la creación de módulos del kernel. Define las estructuras y macros necesarias para declarar la información del módulo, como la licencia, el autor y la descripción.
* **Uso en `proy.c`:** Aquí se definen `MODULE_LICENSE("GPL")`, `MODULE_AUTHOR("Breyson Barrios")` y `MODULE_DESCRIPTION("Módulo que expone datos del kernel para un juego interactivo")`, proporcionando metadatos esenciales sobre el módulo.

### `linux/proc_fs.h`

* **Propósito:** Proporciona las funciones y estructuras necesarias para interactuar con el sistema de archivos `/proc`. Permite a los módulos del kernel crear entradas en `/proc` que pueden ser leídas por aplicaciones en espacio de usuario para obtener información del kernel o para interactuar con él.
* **Uso en `proy.c`:** La función `proc_create()` se utiliza para crear la entrada `/proc/juego_kernel`, y la estructura `proc_ops` se define para especificar las operaciones (abrir, leer, etc.) que se pueden realizar en esta entrada. `remove_proc_entry()` se usa para eliminar la entrada al descargar el módulo.

### `linux/seq_file.h`

* **Propósito:** Esta librería es crucial para generar salidas paginadas y formateadas a archivos `/proc` o cualquier otro archivo virtual del kernel. Simplifica la lectura de datos grandes desde el kernel al espacio de usuario, permitiendo que los datos se generen en "secuencias" sin necesidad de cargar todo en memoria a la vez.
* **Uso en `proy.c`:** `single_open()` se utiliza para inicializar una secuencia de archivo simple, y `seq_printf()` se emplea para escribir la información del sistema de manera formateada en el archivo `juego_kernel`. `seq_read`, `seq_lseek`, y `single_release` son parte de las operaciones estándar para manejar un `seq_file`.

### `linux/mm.h`

* **Propósito:** Contiene definiciones y funciones relacionadas con la gestión de memoria del kernel. En particular, proporciona la estructura `sysinfo` y la función `si_meminfo()` para obtener información sobre el uso de la memoria del sistema.
* **Uso en `proy.c`:** La función `si_meminfo(&i)` se llama para llenar la estructura `sysinfo i` con datos de memoria (RAM total, RAM libre, etc.), los cuales se utilizan posteriormente para mostrar el estado de la memoria del sistema.

### `linux/sched/signal.h`

* **Propósito:** Define estructuras y funciones relacionadas con la gestión de procesos y señales en el kernel. Incluye macros como `for_each_process` que permiten iterar sobre la lista de todas las tareas (procesos) en el sistema.
* **Uso en `proy.c`:** La macro `for_each_process(task)` se utiliza para recorrer la lista de procesos en ejecución y contar el número total de procesos activos en el sistema.

### `linux/jiffies.h`

* **Propósito:** Define la variable global `jiffies`, que es un contador de ticks de temporizador incrementado por el kernel en cada interrupción del temporizador. También define `HZ`, que representa el número de jiffies por segundo. Es fundamental para medir el tiempo de actividad del sistema a nivel del kernel.
* **Uso en `proy.c`:** Se utiliza `jiffies / HZ` para calcular el tiempo de actividad del sistema en segundos, lo cual se muestra en la salida del módulo.

### `linux/timekeeping.h`

* **Propósito:** Proporciona funciones y estructuras para la gestión del tiempo y la sincronización en el kernel, incluyendo la obtención del tiempo del sistema y la manipulación de relojes.
* **Uso en `proy.c`:** Aunque `jiffies` es la fuente principal para el tiempo de actividad en este código, la inclusión de `timekeeping.h` es una buena práctica y puede ser útil si se necesitaran funciones de tiempo más complejas en el futuro.






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

