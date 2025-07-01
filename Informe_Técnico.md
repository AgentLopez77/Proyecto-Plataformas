# 🧠 Informe Técnico - Juego de Adivinanza en C

## 📘 Descripción General del Proyecto

Este proyecto consiste en un **juego interactivo de adivinanza numérica**, desarrollado en lenguaje C, inspirado en los clásicos juegos de texto. La meta del jugador es adivinar un número aleatorio entre **1 y 100**, utilizando datos reales del sistema obtenidos desde un módulo del kernel.

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

Simula un sistema que reacciona a decisiones administrativas del jugador basadas en datos reales del sistema.

#### 🔑 Variables Iniciales

- `puntaje = 100`
- `fallos = 0`

#### 🧩 Funciones Clave

- `cargar_datos_kernel()`: Obtiene datos del sistema desde `/proc/juego_kernel`.
- `nota()`: Muestra explicaciones técnicas.
- `pausa()`: Controla la progresión entre escenas.

#### 🎮 Estructura del Juego

Cada escena presenta un escenario y decisiones como:

1. **Inicio del sistema**
2. **Uso excesivo de CPU**
3. **Intento de intrusión**
4. **Análisis de uptime**
5. **Posible kernel panic**

#### 📊 Final del Juego

- Se muestra el puntaje final y estadísticas.
- Se ofrece una retroalimentación según el rendimiento.

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

## 💻 Requisitos del Sistema

- `gcc` (Compilador C)
- `make`
- Terminal compatible con Bash (Linux, WSL o macOS)

---


## ✅ Conclusiones

Este proyecto es una excelente introducción a:

- Programación en C con interacción al kernel.
- Automatización de compilación con `Makefile`.
- Uso de Bash para construir experiencias interactivas en sistemas Linux.