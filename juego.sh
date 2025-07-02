#!/bin/bash

# Colores para estética
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

reputacion=50
nombre=""

# Función para cargar datos del kernel extraídos desde el módulo
cargar_datos_kernel() {
    if [ ! -f /proc/juego_kernel ]; then
        echo "${red}ERROR: El módulo del kernel no está cargado o /proc/juego_kernel no existe.${reset}"
        exit 1
    fi

    datos=$(cat /proc/juego_kernel)
    kernel=$(echo "$datos" | grep "Versión del kernel" | cut -d ":" -f2 | xargs)
    procesos=$(echo "$datos" | grep "Procesos activos" | cut -d ":" -f2 | xargs)
    ram_total=$(echo "$datos" | grep "RAM total" | cut -d ":" -f2 | xargs)
    ram_libre=$(echo "$datos" | grep "RAM libre" | cut -d ":" -f2 | xargs)
    uptime=$(echo "$datos" | grep "Tiempo de actividad" | cut -d ":" -f2 | xargs)
}

# Portada del juego
intro() {
    clear
    echo -e "${green}"
    echo "	       ██╗  ██╗███████╗██████╗ ███╗   ██╗███████╗██╗     "
    echo "	       ██║ ██╔╝██╔════╝██╔══██╗████╗  ██║██╔════╝██║     "
    echo "	       █████╔╝ █████╗  ██████╔╝██╔██╗ ██║█████╗  ██║     "
    echo "	       ██╔═██╗ ██╔══╝  ██╔══██╗██║╚██╗██║██╔══╝  ██║     "
    echo "	       ██║  ██╗███████╗██║  ██║██║ ╚████║███████╗███████╗"
    echo "	       ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝"
    echo " █████╗ ██████╗ ██╗   ██╗███████╗███╗   ██╗████████╗██╗   ██╗██████╗ ███████╗"
    echo "██╔══██╗██╔══██╗██║   ██║██╔════╝████╗  ██║╚══██╔══╝██║   ██║██╔══██╗██╔════╝"
    echo "███████║██║  ██║██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║██████╔╝█████╗  "
    echo "██╔══██║██║  ██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔══██╗██╔══╝  "
    echo "██║  ██║██████╔╝ ╚████╔╝ ███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██║███████╗"
    echo "╚═╝  ╚═╝╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝"
    echo "      PROYECTO PLATAFORMAS - GRUPO 2 -  MÓDULO DEL KERNEL EN TIEMPO REAL"
    echo -e "${reset}"
    echo
    echo "	        🖥️  ¡Bienvenido, explorador del sistema! 🚀"
    echo 
    echo "En esta aventura de texto única, no solo tomas decisiones… también navegas por"
    echo "el núcleo real de tu sistema operativo.A través de un módulo del kernel hecho "
    echo "especialmente para este juego, accedes a datos reales 🧠: procesos activos, carga"
    echo "del sistema, uso de memoria, etc.Cada escena que vives está conectada con el estado "
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

# Función para mostrar el estado del sistema
mostrar_estado() {
    cargar_datos_kernel
    echo
    echo -e "${blue}--- ESTADO DEL SISTEMA ---${reset}"
    echo "👤 Jugador: $nombre"
    echo "🏆 Reputación: $reputacion"
    echo "🧠 Kernel: $kernel"
    echo "🔧 Procesos activos: $procesos"
    echo "📦 RAM Total: $ram_total kB"
    echo "🟢 RAM Libre: $ram_libre kB"
    echo "⏱ Tiempo encendido: $uptime segundos"
    echo "-----------------------------"
    echo
}

# Función para finalizar el juego
finalizar_juego() {
    echo
    echo -e "${yellow}📝 RESUMEN FINAL:${reset}"
    if [ $reputacion -ge 80 ]; then
        echo -e "${green}🌟 ¡Has salvado el núcleo y mantenido el sistema estable! Eres un verdadero héroe del kernel.${reset}"
    elif [ $reputacion -ge 50 ]; then
        echo -e "${cyan}🔧 Tu gestión fue aceptable, pero hay espacio para mejorar la estabilidad del sistema.${reset}"
    else
        echo -e "${red}💥 Has perdido el control del sistema. El kernel ha colapsado por tus malas decisiones.${reset}"
    fi
    echo
    echo -e "${blue}¡Gracias por jugar, $nombre!${reset}"
    exit 0
}

# Escena genérica para tomar decisiones
escena() {
    local numero="$1"
    local descripcion="$2"
    local opcion1="$3"
    local efecto1="$4"
    local opcion2="$5"
    local efecto2="$6"

    echo -e "${yellow}🔸 ESCENA $numero:${reset} $descripcion"
    mostrar_estado
    echo "1) $opcion1"
    echo "2) $opcion2"
    read -p "¿Qué decides hacer? [1/2] ➤ " eleccion
    if [ "$eleccion" == "1" ]; then
        reputacion=$((reputacion + efecto1))
        echo -e "${green}✔ Decisión aplicada. Reputación +${efecto1}.${reset}"
    else
        reputacion=$((reputacion + efecto2))
        echo -e "${red}✘ Decisión aplicada. Reputación +${efecto2}.${reset}"
    fi
    sleep 2
    clear
}

# Escenas del juego
jugar() {
    intro

    escena 1 "Se detecta alta carga de procesos inesperada en el sistema." \
        "Investigas y cierras procesos inactivos." 10 \
        "Ignoras el problema." -10

    escena 2 "El uso de RAM está creciendo peligrosamente." \
        "Limpiar cachés de forma segura." 10 \
        "Ignorar, esperas que el sistema lo maneje." -10

    escena 3 "Detectas vulnerabilidades en el kernel actual." \
        "Parcheas y recompilas el kernel." 15 \
        "Dejas el kernel vulnerable por ahora." -15

    escena 4 "Una actualización del sistema requiere reinicio inmediato." \
        "Programas reinicio y notificas a usuarios." 10 \
        "Reinicias sin aviso previo, causando caos." -20

    escena 5 "Usuarios reportan lentitud." \
        "Revisas logs y ajustas políticas de I/O." 10 \
        "Aumentas el swap sin revisar causas." -10

    escena 6 "El número de procesos alcanza niveles inusuales." \
        "Monitorea y ajusta límites de usuarios." 10 \
        "No haces nada, esperas que bajen solos." -10

    escena 7 "El tiempo de actividad muestra signos de inestabilidad por uptime prolongado." \
        "Realizas mantenimiento proactivo." 10 \
        "Ignoras el estado actual del sistema." -10

    escena 8 "La RAM libre está llegando a cero." \
        "Identificas y detienes procesos maliciosos." 10 \
        "Reinicias el servicio más pesado sin diagnóstico." -10

    escena 9 "Detectas intentos de intrusión SSH." \
        "Refuerzas la seguridad y bloqueas IPs." 10 \
        "Solo reinicias el servicio SSH." -10

    escena 10 "El sistema ha sido estable, ¿finalizas la sesión?" \
        "Documentas y cierras sesión limpiamente." 10 \
        "Te vas sin cerrar sesión, dejándolo vulnerable." -10

    finalizar_juego
}

# Iniciar juego
jugar
