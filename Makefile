# Este Makefile compila el módulo del kernel para el juego
# 'proy.o' es el archivo objeto generado a partir de proy.c

obj-m += proy.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
