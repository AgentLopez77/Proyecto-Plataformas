
# Archivo Makefile para compilar el módulo del kernel proy.c

# Objeto principal
obj-m += proy.o

# Ruta del núcleo en ejecución
KDIR := /lib/modules/$(shell uname -r)/build
PWD  := $(shell pwd)

# Regla principal: compila el módulo
all:
	make -C $(KDIR) M=$(PWD) modules

# Limpia archivos de compilación anteriores
clean:
	make -C $(KDIR) M=$(PWD) clean

# Corrige advertencias por archivos con hora de modificación "en el futuro"
fix_time:
	@echo "⏳ Corrigiendo fechas de archivos modificados en el futuro..."
	find . -type f -exec touch {} +

# Compilación segura: primero corrige hora, luego compila
safe_all: fix_time all
