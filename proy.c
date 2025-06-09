//Librerias
#include <linux/init.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/uaccess.h>
#include <linux/kernel.h>

#define PROC_NAME "estado_sistema"
#define MAX_BUF 128


//Estado del sistema
typedef struct {
    int reputacion;
    int usoCPU;
    int usoRAM;
    int integridadFS;
    int seguridad;
    int kernelPanic;
} EstadoSistema;

static EstadoSistema estado = {50, 80, 60, 100, 100, 0};
static char proc_buffer[MAX_BUF];

static ssize_t proc_read(struct file *file, char __user *user_buffer,
                         size_t count, loff_t *offset) {
    char output[512];
    int len;

    if (*offset > 0)
        return 0;

        //Imprime los datos del sitema
    len = snprintf(output, sizeof(output),
        "== ESTADO DEL SISTEMA ==\n"
        "Reputación: %d\n"
        "Uso CPU simulado: %d%%\n"
        "Uso RAM simulado: %d%%\n"
        "Integridad FS: %d\n"
        "Seguridad: %d\n"
        "Kernel Panic: %s\n\n"
        "Opciones para simular (escribe en /proc/%s):\n"
        "1 - Matar proceso crítico\n"
        "2 - Cambiar política de planificación\n"
        "3 - No hacer nada\n",
        estado.reputacion, estado.usoCPU, estado.usoRAM,
        estado.integridadFS, estado.seguridad,
        estado.kernelPanic ? "Sí" : "No",
        PROC_NAME);

    if (copy_to_user(user_buffer, output, len))
        return -EFAULT;

    *offset = len;
    return len;
}

//casos posibles
static ssize_t proc_write(struct file *file, const char __user *user_buffer,
                          size_t count, loff_t *offset) {
    int cmd;

    if (count >= MAX_BUF)
        return -EINVAL;

    if (copy_from_user(proc_buffer, user_buffer, count))
        return -EFAULT;

    proc_buffer[count] = '\0';

    if (kstrtoint(proc_buffer, 10, &cmd) != 0)
        return -EINVAL;

    switch (cmd) {
        case 1:
            printk(KERN_INFO "[estado_sistema] Proceso crítico muerto: Kernel Panic\n");
            estado.kernelPanic = 1;
            estado.reputacion -= 30;
            break;
        case 2:
            printk(KERN_INFO "[estado_sistema] Política cambiada. CPU estabilizada\n");
            estado.usoCPU -= 20;
            if (estado.usoCPU < 0) estado.usoCPU = 0;
            estado.reputacion += 10;
            break;
        case 3:
            printk(KERN_INFO "[estado_sistema] No hiciste nada. El problema persiste\n");
            estado.reputacion -= 5;
            break;
        default:
            printk(KERN_INFO "[estado_sistema] Comando no válido: %d\n", cmd);
            break;
    }

    return count;
}

static const struct proc_ops proc_file_ops = {
    .proc_read = proc_read,
    .proc_write = proc_write,
};

static int __init estado_init(void) {
    proc_create(PROC_NAME, 0666, NULL, &proc_file_ops);
    printk(KERN_INFO "[estado_sistema] /proc/%s creado\n", PROC_NAME);
    return 0;
}

static void __exit estado_exit(void) {
    remove_proc_entry(PROC_NAME, NULL);
    printk(KERN_INFO "[estado_sistema] Módulo descargado\n");
}

module_init(estado_init);
module_exit(estado_exit);
