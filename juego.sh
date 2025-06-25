

#!/bin/bash

# Variables iniciales
puntaje=100
fallos=0

# Cargar datos reales desde el módulo del kernel
cargar_datos_kernel() {
    datos=$(cat /proc/juego_kernel)
    procesos=$(echo "$datos" | grep "Procesos activos" | awk '{print $3}')
    ram_total=$(echo "$datos" | grep "RAM total" | awk '{print $3}')
    ram_libre=$(echo "$datos" | grep "RAM libre" | awk '{print $3}')
    uptime=$(echo "$datos" | grep "Tiempo de actividad" | awk '{print $4}')
}

# Nota técnica para explicar decisiones
nota() {
    echo -e "\033[0;36m🧠 Nota técnica:\033[0m $1"
    echo ""
}

# Pausa con limpieza de pantalla
pausa() {
    echo ""
    read -p "Presiona Enter para continuar..." dummy
    clear
}

# Pantalla de bienvenida
clear
echo -e "\033[1;35m"
echo "╔══════════════════════════════════════════════╗"
echo "║         NÚCLEO: LA ÚLTIMA DEFENSA ⚙️         ║"
echo "╠══════════════════════════════════════════════╣"
echo "║  Simulador interactivo de gestión del kernel ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "\033[0m"
echo "Tú eres el núcleo del sistema Linux. Cada decisión que tomes"
echo "afectará la estabilidad, seguridad y rendimiento del sistema."
echo "Este juego utiliza datos reales extraídos desde el núcleo mediante un módulo personalizado."
pausa

# ESCENA 1
echo -e "\033[1;34m🌐 ESCENA 1: EL SISTEMA DESPIERTA\033[0m"
echo "El sistema ha iniciado después de un apagón inesperado."
echo "¿Qué deseas revisar primero?"
echo "1) Estado de la memoria RAM"
echo "2) Estado de procesos activos"
read -p "Tu decisión: " esc1
cargar_datos_kernel
if [ "$esc1" = "1" ]; then
    echo "📊 RAM libre actual: ${ram_libre} KB"
    nota "Este valor se obtuvo del módulo del kernel accediendo directamente a 'si_meminfo'."
    if [ "$ram_libre" -lt 200000 ]; then
        echo "❗ La RAM está casi llena. Inicias limpieza."
        puntaje=$((puntaje+10))
    else
        echo "✔️ Buena cantidad de memoria. Todo en orden."
    fi
else
    echo "📊 Procesos activos: $procesos"
    nota "El total de procesos fue obtenido con 'for_each_process' dentro del módulo."
    if [ "$procesos" -gt 200 ]; then
        echo "❗ Muchos procesos detectados. Tomas medidas."
        puntaje=$((puntaje+10))
    else
        echo "✔️ El número de procesos es razonable."
    fi
fi
pausa

# ESCENA 2
echo -e "\033[1;34m🔥 ESCENA 2: CPU AL LÍMITE\033[0m"
echo "Un proceso desconocido está usando el 99% del CPU."
echo "¿Qué haces?"
echo "1) Matar el proceso sospechoso"
echo "2) Cambiar la política de planificación"
echo "3) Ignorar"
read -p "Tu decisión: " esc2
case "$esc2" in
    1)
        echo "⚠️ Era un proceso del sistema. Provocas inestabilidad."
        puntaje=$((puntaje-25))
        fallos=$((fallos+1))
        ;;
    2)
        echo "✅ Redistribuyes recursos. CPU estabilizada."
        puntaje=$((puntaje+15))
        ;;
    *)
        echo "❌ La CPU colapsó. El sistema se congeló por 10 segundos."
        puntaje=$((puntaje-20))
        fallos=$((fallos+1))
        ;;
esac
nota "Cambiar la política de planificación puede reordenar prioridades para salvar estabilidad."
pausa

# ESCENA 3
echo -e "\033[1;34m🔐 ESCENA 3: INTRUSIÓN SOSPECHOSA\033[0m"
echo "Un usuario intenta escalar privilegios usando 'sudo'."
echo "1) Revocar permisos temporalmente"
echo "2) Registrar el evento y permitir el acceso"
read -p "Tu decisión: " esc3
if [ "$esc3" = "1" ]; then
    echo "🛡️ Acceso bloqueado. Se evitó una posible escalada."
    puntaje=$((puntaje+10))
else
    echo "⚠️ El usuario comprometió credenciales root."
    puntaje=$((puntaje-30))
    fallos=$((fallos+1))
fi
nota "Las cuentas con permisos administrativos deben monitorearse constantemente."
pausa

# ESCENA 4
echo -e "\033[1;34m🧠 ESCENA 4: TIEMPO DE ACTIVIDAD\033[0m"
echo "Analizas la estabilidad del sistema basándote en su tiempo activo:"
echo "📊 Tiempo activo: ${uptime} segundos"
nota "Este valor se obtuvo desde jiffies y convertido dentro del módulo del kernel."
echo "¿Reiniciar el sistema suavemente?"
echo "1) Sí"
echo "2) No"
read -p "Tu decisión: " esc4
if [ "$esc4" = "1" ]; then
    echo "♻️ El sistema fue reiniciado. Todo quedó en estado limpio."
    puntaje=$((puntaje+10))
else
    echo "⚠️ Sigues operando pero se acumulan pequeños errores."
    puntaje=$((puntaje-10))
fi
pausa

# ESCENA 5
echo -e "\033[1;34m💣 ESCENA 5: POSIBLE KERNEL PANIC\033[0m"
echo "Un driver falló al acceder a una dirección de memoria inválida."
echo "¿Qué haces?"
echo "1) Aislar el driver fallido"
echo "2) Reiniciar el subsistema"
read -p "Tu decisión: " esc5
if [ "$esc5" = "1" ]; then
    echo "🧯 El sistema se estabilizó."
    puntaje=$((puntaje+15))
else
    echo "💥 El reinicio falló. El sistema se reinició por kernel panic."
    puntaje=$((puntaje-25))
    fallos=$((fallos+1))
fi
nota "El kernel puede caer en pánico si intenta ejecutar código en zonas inválidas."
pausa

# FINAL
clear
echo -e "\033[1;32m🎮 FIN DEL JUEGO - ESTADÍSTICAS:\033[0m"
echo "🧾 Puntaje final: $puntaje"
echo "❌ Fallos cometidos: $fallos"
echo ""
if [ "$puntaje" -ge 80 ] && [ "$fallos" -lt 3 ]; then
    echo -e "\033[1;33m🎉 ¡Excelente! Lograste mantener la estabilidad del sistema como un verdadero administrador de núcleo.\033[0m"
else
    echo -e "\033[1;31m💀 El sistema cayó en caos por decisiones críticas. Repasa conceptos del kernel.\033[0m"
fi
echo ""
echo -e "\033[0;36m📌 Todos los datos mostrados en este juego provienen directamente de un módulo del kernel, cargado en tiempo real.\033[0m"
 
 
