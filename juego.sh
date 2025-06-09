#!/bin/bash

PROC_FILE="/proc/estado_sistema"

if [ ! -e "$PROC_FILE" ]; then
    echo "El módulo no está cargado. Ejecuta: sudo insmod proy.ko"
    exit 1
fi

while true; do
    clear
    echo "===== ESTADO DEL SISTEMA ====="
    cat "$PROC_FILE"
    echo
    echo "== Menú de acciones =="
    echo "1 - Matar proceso crítico (simulado)"
    echo "2 - Cambiar política de planificación"
    echo "3 - No hacer nada"
    echo "0 - Salir"
    echo
    read -p "Selecciona una opción: " opcion

    case "$opcion" in
        1|2|3)
            sudo sh -c "echo $opcion > $PROC_FILE"
            echo
            echo "→ Resultado del sistema:"
            sudo dmesg | tail -n 3
            sleep 2
            ;;
        0)
            echo "Saliendo..."
            break
            ;;
        *)
            echo "Opción inválida. Intenta de nuevo."
            sleep 1
            ;;
    esac
done


 
