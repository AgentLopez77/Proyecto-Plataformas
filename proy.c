// Módulo del kernel para exponer datos reales al juego
#include <linux/init.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/mm.h>
#include <linux/sched/signal.h>
#include <linux/jiffies.h>
#include <linux/timekeeping.h>

#define PROC_NAME "juego_kernel"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Breyson Barrios");
MODULE_DESCRIPTION("Módulo que expone datos del kernel para un juego interactivo");

static int mostrar_info(struct seq_file *m, void *v) {
    struct sysinfo i;
    struct task_struct *task;
    int procesos = 0;

    // Memoria
    si_meminfo(&i);

    // Contar procesos activos
    for_each_process(task) {
        procesos++;
    }

    // Tiempo de actividad en segundos
    unsigned long uptime = jiffies / HZ;

    seq_printf(m, "== ESTADO DEL SISTEMA DEL KERNEL ==\n");
    seq_printf(m, "Procesos activos: %d\n", procesos);
    seq_printf(m, "RAM total: %lu KB\n", (i.totalram * i.mem_unit) / 1024);
    seq_printf(m, "RAM libre: %lu KB\n", (i.freeram * i.mem_unit) / 1024);
    seq_printf(m, "Tiempo de actividad: %lu segundos\n", uptime);
    return 0;
}

static int abrir_proc(struct inode *inode, struct file *file) {
    return single_open(file, mostrar_info, NULL);
}

static const struct proc_ops operaciones = {
    .proc_open = abrir_proc,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release,
};

static int __init iniciar_modulo(void) {
    proc_create(PROC_NAME, 0, NULL, &operaciones);
    printk(KERN_INFO "🧠 [juego_kernel] Módulo cargado correctamente\n");
    return 0;
}

static void __exit salir_modulo(void) {
    remove_proc_entry(PROC_NAME, NULL);
    printk(KERN_INFO "🧠 [juego_kernel] Módulo descargado\n");
}

module_init(iniciar_modulo);
module_exit(salir_modulo);
