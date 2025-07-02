// Módulo del kernel para el juego: expone datos reales del sistema
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/sched/signal.h>
#include <linux/mm.h>
#include <linux/utsname.h>
#include <linux/jiffies.h>
#include <linux/time.h>

#define PROC_NAME "juego_kernel"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Breyson");
MODULE_DESCRIPTION("Modulo para extraer datos reales del kernel para un juego educativo");
MODULE_VERSION("1.0");

// Esta función se llama cada vez que alguien hace 'cat /proc/juego_kernel'
static int escribir_proc(struct seq_file *archivo, void *v) {
    struct sysinfo i;
    int procesos = 0;
    struct task_struct *tarea;
    unsigned long uptime;

    // Obtener información de memoria del sistema
    si_meminfo(&i);

    // Contar procesos en ejecución (TASK_RUNNING)
    for_each_process(tarea) {
        if (task_is_running(tarea)) {
            procesos++;
        }
    }

    // Calcular tiempo de actividad del sistema (en segundos)
    uptime = jiffies / HZ;

    // Obtener versión del kernel usando init_uts_ns.name.release
    const char *version = init_uts_ns.name.release;

    // Escribir toda la información en el archivo virtual
    seq_printf(archivo, "Versión del kernel: %s\n", version);
    seq_printf(archivo, "Tiempo de actividad: %lu segundos\n", uptime);
    seq_printf(archivo, "Procesos activos: %d\n", procesos);
    seq_printf(archivo, "RAM total: %lu kB\n", (i.totalram * 4) / 1024);
    seq_printf(archivo, "RAM libre: %lu kB\n", (i.freeram * 4) / 1024);

    return 0;
}

// Funciones auxiliares requeridas para /proc
static int abrir_proc(struct inode *inode, struct file *file) {
    return single_open(file, escribir_proc, NULL);
}

static const struct proc_ops operaciones = {
    .proc_open = abrir_proc,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release,
};

// Función que se ejecuta al insertar el módulo con insmod
static int __init iniciar_modulo(void) {
    proc_create(PROC_NAME, 0, NULL, &operaciones);
    printk(KERN_INFO "[juego_kernel] Módulo cargado. Archivo /proc/%s creado\n", PROC_NAME);
    return 0;
}

// Función que se ejecuta al remover el módulo con rmmod
static void __exit salir_modulo(void) {
    remove_proc_entry(PROC_NAME, NULL);
    printk(KERN_INFO "[juego_kernel] Módulo eliminado. Archivo /proc/%s removido\n", PROC_NAME);
}

module_init(iniciar_modulo);
module_exit(salir_modulo);
