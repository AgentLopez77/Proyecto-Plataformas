#!/bin/bash

# Configuración de colores para la interfaz del juego
# Usamos 'tput' para cambiar los colores del texto en consola y mejorar la presentación visual.

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

#  Variables del juego
# 'reputacion' es el puntaje del jugador. 'nombre' se solicita al iniciar el juego.

reputacion=50
nombre=""

# Función que carga los datos del sistema desde el módulo del kernel.
# Lee el archivo /proc/juego_kernel línea por línea y extrae la información del sistema real.
# Verifica que el archivo exista; si no, lanza un error.

cargar_datos_kernel() {
    if [ ! -f /proc/juego_kernel ]; then
        echo "${red}ERROR: El módulo del kernel no está cargado o /proc/juego_kernel no existe.${reset}"
        exit 1
    fi

    # Reiniciar variables
    
    kernel=""
    procesos=""
    ram_total=""
    ram_libre=""
    uptime=""
    carga=""
    pid=""
    ppid=""
    uid=""

      # Lee el archivo del módulo y asigna valores a las variables
      
    while IFS=":" read -r clave valor; do
        clave=$(echo "$clave" | xargs)
        valor=$(echo "$valor" | xargs)
        case "$clave" in
            "Versión del kernel") kernel=$valor ;;
            "Procesos activos") procesos=$valor ;;
            "RAM total") ram_total=$valor ;;
            "RAM libre") ram_libre=$valor ;;
            "Tiempo de actividad (segundos)") uptime=$valor ;;
            "Carga promedio (1 min)") carga=$valor ;;
            "PID actual") pid=$valor ;;
            "PID padre") ppid=$valor ;;
            "UID del usuario actual") uid=$valor ;;
        esac
    done < /proc/juego_kernel
}

# Función de introducción al juego
# Muestra arte ASCII y una breve historia para ambientar la experiencia del jugador.
# También solicita el nombre del jugador.

intro() {
    clear
    echo -e "${green}"
    echo "            ██╗  ██╗███████╗██████╗ ███╗   ██╗███████╗██╗     "
    echo "            ██║ ██╔╝██╔════╝██╔══██╗████╗  ██║██╔════╝██║     "
    echo "            █████╔╝ █████╗  ██████╔╝██╔██╗ ██║█████╗  ██║     "
    echo "            ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╗██║██╔══╝  ██║     "
    echo "            ██║  ██╗███████╗██║  ██║██║ ╚████║███████╗███████╗"
    echo "            ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
    echo " █████╗ ██████╗ ██╗   ██╗███████╗███╗   ██╗████████╗██╗   ██╗██████╗ ███████╗"
    echo "██╔══██╗██╔══██╗██║   ██║██╔════╝████╗  ██║╚══██╔══╝██║   ██║██╔══██╗██╔════╝"
    echo "███████║██║  ██║██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║██████╔╝█████╗  "
    echo "██╔══██║██║  ██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔══██╗██╔══╝  "
    echo "██║  ██║██████╔╝ ╚████╔╝ ███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██║███████╗"
    echo "╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝"
    echo "      PROYECTO PLATAFORMAS - GRUPO 2 -  MÓDULO DEL KERNEL EN TIEMPO REAL"
    echo -e "${reset}"
    echo
    echo "              🖥️  ¡Bienvenido, explorador del sistema! 🚀"
    echo 
    echo "En esta aventura de texto única, no solo tomas decisiones… también navegas por"
    echo "el núcleo real de tu sistema operativo. A través de un módulo del kernel hecho "
    echo "especialmente para este juego, accedes a datos reales 🧠: procesos activos, carga"
    echo "del sistema, uso de memoria, etc. Cada escena que vives está conectada con el estado "
    echo "real del sistema."
    echo
    echo "⚠️ Elige con cuidado, analiza los datos y defiende la estabilidad del sistema 🛡️."
    echo
    echo "                  El Kernel está vivo… y vos sos parte de él.                      "
    echo 
    echo "¿Estás listo para sumergirte en el corazón del sistema? 💻🔥"
    echo
    read -p "👤 INGRESE EL NOMBRE DEL JUGADOR: " nombre
    clear
}

# Función para mostrar el estado actual del sistema
# Muestra los datos cargados desde el módulo, como RAM, carga, procesos y PID.

mostrar_estado() {
    cargar_datos_kernel
    echo -e "${blue}--- ESTADO DEL SISTEMA ---${reset}"
    echo "👤 Jugador: $nombre"
    echo "🏆 Reputación: $reputacion"
    echo "🧠 Kernel: $kernel"
    echo "🔧 Procesos activos: $procesos"
    echo "📦 RAM Total: $ram_total "
    echo "🟢 RAM Libre: $ram_libre "
    echo "⚖ Carga promedio (1min): $carga"
    echo "⏱ Uptime: $uptime segundos"
    echo "🔢 PID actual: $pid | PID padre: $ppid"
    echo "🧑 UID del usuario: $uid"
    echo "-----------------------------"
    echo
}

# Función para mostrar el final del juego
# Muestra un mensaje diferente según la reputación del jugador acumulada durante el juego.

finalizar_juego() {
    echo
    echo -e "${yellow}📝 RESUMEN FINAL:${reset}"
    if [ $reputacion -ge 80 ]; then
        echo -e "${green}🌟 ¡Has salvado el núcleo y mantenido el sistema estable!${reset}"
    elif [ $reputacion -ge 50 ]; then
        echo -e "${cyan}🔧 Tu gestión fue aceptable. Puedes mejorar aún más.${reset}"
    else
        echo -e "${red}💥 El sistema colapsó por malas decisiones.${reset}"
    fi
    echo -e "${blue}¡Gracias por jugar, $nombre!${reset}"
    exit 0
}

# Función para cada escena del juego
# Muestra una situación, las 3 decisiones posibles y ajusta la reputación según la elección.
# Esta función se reutiliza para cada escenario con diferentes parámetros.

escena3() {
    local numero="$1"
    local descripcion="$2"
    local opcion1="$3" efecto1="$4"
    local opcion2="$5" efecto2="$6"
    local opcion3="$7" efecto3="$8"

    echo -e "${yellow}🔸 ESCENA $numero:${reset} $descripcion"
    mostrar_estado
    echo "1) $opcion1"
    echo "2) $opcion2"
    echo "3) $opcion3"
    read -p "¿Qué decides hacer? [1/2/3] ➤ " eleccion

    case $eleccion in
        1) reputacion=$((reputacion + efecto1));;
        2) reputacion=$((reputacion + efecto2));;
        3) reputacion=$((reputacion + efecto3));;
        *) echo "Opción inválida."; sleep 1;;
    esac
    sleep 2
    clear
}

# Función principal que ejecuta todo el juego
# Ejecuta la introducción, llama a cada escena con datos reales y finaliza el juego.

jugar() {
    intro
cargar_datos_kernel
    escena3 1 "El sistema reporta una carga promedio de $carga con $procesos procesos activos." \
        "Reducís tareas pesadas y priorizás servicios críticos." 10 \
        "Desactivás temporalmente el monitoreo del sistema." -5 \
        "Aumentás procesos de respaldo sin ajustar prioridades." -10

    escena3 2 "Solo quedan $ram_libre de RAM libre y un usuario va a abrir un navegador con múltiples pestañas." \
        "Limitás recursos del navegador y liberás memoria." 10 \
        "Ignorás el uso de RAM y dejás que se sature." -10 \
        "Permitís que se ejecute pero limitás las pestañas activas." -5

    escena3 3 "El sistema lleva $uptime segundos encendido. Hay logs acumulados desde hace semanas." \
        "Planificás limpieza y reinicio controlado." 10 \
        "Ignorás la limpieza para no detener servicios." -5 \
        "Reiniciás a la fuerza sin respaldo." -10

    escena3 4 "El proceso actual (PID $pid) fue lanzado por el padre $ppid. Sospechás comportamiento anómalo." \
        "Auditás el proceso y validás con logs antes de actuar." 10 \
        "Matás el proceso a ciegas sin investigar consecuencias." -10 \
        "Esperás a que el proceso termine por sí solo." -5

    escena3 5 "El kernel en uso es $kernel, y hay una nueva versión que soluciona bugs críticos." \
        "Probás primero en entorno de prueba y actualizás." 10 \
        "Actualizás directo sin verificar compatibilidad." -5 \
        "Decidís mantener la versión actual por comodidad." -10

    escena3 6 "El sistema tiene $procesos procesos y la carga subió a $carga. Algunos servicios están lentos." \
        "Priorizás servicios clave y pausás tareas no críticas." 10 \
        "Reiniciás servicios sin notificar usuarios." -5 \
        "Aumentás hilos sin revisar consumo de CPU." -10

    escena3 7 "Un usuario con UID $uid ejecuta múltiples scripts pesados simultáneamente." \
        "Le asignás límites con cgroups y avisás al usuario." 10 \
        "Bloqueás su cuenta sin explicación." -10 \
        "Dejás que sus scripts sigan corriendo sin intervenir." -5

    escena3 8 "Solo hay $ram_libre libres y otro servicio planea iniciar ahora." \
        "Suspendés el inicio hasta liberar memoria." 10 \
        "Forzás el arranque ignorando el riesgo de OOM." -10 \
        "Asignás swap temporal antes de iniciar." -5

    escena3 9 "El sistema muestra una carga de $carga y uptime de $uptime segundos. Varios procesos no responden." \
        "Ejecutás monitoreo activo y reconfigurás prioridades." 10 \
        "Reiniciás el sistema sin guardar estado." -5 \
        "Esperás más tiempo sin actuar." -10

    escena3 10 "Con $procesos procesos activos, recibís una solicitud para ejecutar un análisis profundo del sistema." \
        "Programás el análisis en horas de baja carga." 10 \
        "Lo ejecutás ahora, causando lentitud." -5 \
        "Lo rechazás sin justificar al usuario." -10

    finalizar_juego
}

# Llamada final que inicia el juego al ejecutar el script
jugar
