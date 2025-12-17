#!/bin/bash
#
# run.sh
# Script para ejecutar Brain Workshop en el entorno virtual
#

# Ir al directorio del script
cd "$(dirname "$0")"

# Verificar si existe el entorno virtual
if [ ! -d "venv" ]; then
    echo "Error: No se encontró el entorno virtual"
    echo "Ejecuta primero: ./setup_espanol.sh"
    exit 1
fi

# Activar entorno virtual
source venv/bin/activate

# Ejecutar Brain Workshop
python brainworkshop.pyw "$@"

# Desactivar entorno virtual al salir
deactivate
