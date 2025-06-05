
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUFFER 256

typedef struct {
    int reputacion;
    int usoCPU;
    int usoRAM;
    int integridadFS;
    int seguridad;
    int kernelPanic;
} EstadoSistema;

void leerLoadavg(char *buffer) {
    FILE *fp = fopen("/proc/loadavg", "r");
    if (!fp) {
        perror("No se pudo abrir /proc/loadavg");
        strcpy(buffer, "Error leyendo loadavg.");
        return;
    }
    fgets(buffer, MAX_BUFFER, fp);
    fclose(fp);
}

void leerMeminfo(char *buffer) {
    FILE *fp = fopen("/proc/meminfo", "r");
    if (!fp) {
        perror("No se pudo abrir /proc/meminfo");
        strcpy(buffer, "Error leyendo meminfo.");
        return;
    }
    fgets(buffer, MAX_BUFFER, fp);  // Solo primera línea (MemTotal)
    fclose(fp);
}

void mostrarEstado(EstadoSistema *estado) {
    printf("== ESTADO DEL SISTEMA ==\n");
    printf("Reputación: %d\n", estado->reputacion);
    printf("Uso CPU simulado: %d%%\n", estado->usoCPU);
    printf("Uso RAM simulado: %d%%\n", estado->usoRAM);
    printf("Integridad FS: %d\n", estado->integridadFS);
    printf("Seguridad: %d\n", estado->seguridad);
    printf("Kernel Panic: %s\n\n", estado->kernelPanic ? "Sí" : "No");
}

void escenaInicial(EstadoSistema *estado) {
    printf("== ALERTA: Lentitud del sistema ==\n");
    printf("Analiza antes de actuar:\n");
    printf("1. Ver /proc/loadavg\n");
    printf("2. Ver /proc/meminfo\n");
    printf("3. Tomar decisión sin analizar (no recomendado)\n");
    int opcion;
    char buffer[MAX_BUFFER];
    printf("Opción: ");
    scanf("%d", &opcion);
    getchar();  // limpiar buffer
    switch(opcion) {
        case 1:
            leerLoadavg(buffer);
            printf("Contenido de /proc/loadavg:\n%s\n", buffer);
            break;
        case 2:
            leerMeminfo(buffer);
            printf("Contenido de /proc/meminfo:\n%s\n", buffer);
            break;
        case 3:
            printf("Decidiste actuar sin datos...\n");
            estado->reputacion -= 10;
            break;
        default:
            printf("Opción inválida.\n");
            break;
    }

    printf("\n== DECISIÓN ==\n");
    printf("1. Matar proceso más pesado (simulado)\n");
    printf("2. Cambiar política de planificación (simulado)\n");
    printf("3. No hacer nada\n");
    scanf("%d", &opcion);
    switch(opcion) {
        case 1:
            printf("Mataste un proceso crítico accidentalmente. ¡Kernel panic!\n");
            estado->kernelPanic = 1;
            estado->reputacion -= 30;
            break;
        case 2:
            printf("Cambiaste la política. El sistema se estabiliza parcialmente.\n");
            estado->usoCPU -= 20;
            estado->reputacion += 10;
            break;
        case 3:
            printf("No hiciste nada. El problema persiste.\n");
            estado->reputacion -= 5;
            break;
        default:
            printf("Opción inválida.\n");
            break;
    }

    mostrarEstado(estado);
}

int main() {
    EstadoSistema estado = {50, 80, 60, 100, 100, 0};
    escenaInicial(&estado);
    if (estado.kernelPanic) {
        printf("== FIN DEL JUEGO: El sistema entró en kernel panic ==\n");
    } else {
        printf("== FIN DE LA ESCENA 1 ==\n");
    }
    return 0;
}
