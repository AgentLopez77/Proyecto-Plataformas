
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/sched/signal.h>
#include <linux/mm.h>
#include <linux/sched.h>
#include <linux/utsname.h>
#include <linux/time.h>
#include <linux/fs.h>
#include <linux/cred.h>
#include <linux/uaccess.h>
#include <linux/ktime.h>

#define NOMBRE_ARCHIVO "juego_kernel"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Grupo 2");
MODULE_DESCRIPTION("Modulo que expone info real del sistema para juego interactivo");

static int escribir_info(struct seq_file *archivo, void *v) {
    struct sysinfo i;
    struct task_struct *tarea;
    int procesos = 0;

    si_meminfo(&i);

    // Contar procesos activos
    for_each_process(tarea) {
        procesos++;
    }

    // Uptime y carga
    unsigned long uptime = ktime_get_boottime_seconds();
    unsigned long load = i.loads[0] / (1 << SI_LOAD_SHIFT);  // conversión correcta

    // PID actual y padre
    pid_t pid = current->pid;
    pid_t ppid = current->real_parent->pid;

    // UID del usuario actual
    kuid_t uid = current_uid();

    // Información para el juego
    seq_printf(archivo, "Versión del kernel: %s\n", utsname()->release);
    seq_printf(archivo, "Tiempo de actividad (segundos): %lu\n", uptime);
    seq_printf(archivo, "Procesos activos: %d\n", procesos);
    seq_printf(archivo, "RAM total: %lu\n", i.totalram * 4);
    seq_printf(archivo, "RAM libre: %lu\n", i.freeram * 4);
    seq_printf(archivo, "Carga promedio (1 min): %lu\n", load);
    seq_printf(archivo, "PID actual: %d\n", pid);
    seq_printf(archivo, "PID padre: %d\n", ppid);
    seq_printf(archivo, "UID del usuario actual: %d\n", uid.val);

    return 0;
}

static int abrir(struct inode *inode, struct file *file) {
    return single_open(file, escribir_info, NULL);
}

static struct proc_ops ops = {
    .proc_open = abrir,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release
};

static int __init iniciar(void) {
    proc_create(NOMBRE_ARCHIVO, 0, NULL, &ops);
    printk(KERN_INFO "Modulo cargado correctamente.\n");
    return 0;
}

static void __exit salir(void) {
    remove_proc_entry(NOMBRE_ARCHIVO, NULL);
    printk(KERN_INFO "Modulo eliminado correctamente.\n");
}

module_init(iniciar);
module_exit(salir);
