#!/bin/bash
#
# setup_espanol.sh
# Script de configuración para Brain Workshop en Español
# Crea un entorno virtual aislado y prepara todo para agregar audios en español
#

set -e  # Salir si hay algún error

echo "=========================================="
echo "Brain Workshop - Configuración en Español"
echo "=========================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Directorio del proyecto
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$PROJECT_DIR"

echo -e "${GREEN}Directorio del proyecto:${NC} $PROJECT_DIR"
echo ""

# Verificar Python 2
echo "1. Verificando Python 2..."
if command -v python2.7 &> /dev/null; then
    PYTHON_CMD=python2.7
    echo -e "${GREEN}✓${NC} Python 2.7 encontrado"
elif command -v python2 &> /dev/null; then
    PYTHON_CMD=python2
    echo -e "${GREEN}✓${NC} Python 2 encontrado"
else
    echo -e "${RED}✗${NC} Python 2 no encontrado"
    echo "Instala Python 2 con: sudo apt-get install python2.7"
    exit 1
fi

# Verificar virtualenv
echo "2. Verificando virtualenv..."
if ! command -v virtualenv &> /dev/null; then
    echo -e "${YELLOW}!${NC} virtualenv no encontrado, instalando..."
    sudo apt-get update
    sudo apt-get install -y python-virtualenv
fi
echo -e "${GREEN}✓${NC} virtualenv disponible"

# Crear entorno virtual
echo "3. Creando entorno virtual..."
if [ -d "venv" ]; then
    echo -e "${YELLOW}!${NC} El entorno virtual ya existe"
    read -p "¿Deseas recrearlo? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -rf venv
        # Crear venv usando el Python seleccionado
        $PYTHON_CMD -m virtualenv venv
        echo -e "${GREEN}✓${NC} Entorno virtual recreado"
    else
        echo "Usando entorno virtual existente"
    fi
else
    # Crear venv usando el Python seleccionado
    $PYTHON_CMD -m virtualenv venv
    echo -e "${GREEN}✓${NC} Entorno virtual creado"
fi

# Activar entorno virtual
echo "4. Activando entorno virtual..."
source venv/bin/activate
echo -e "${GREEN}✓${NC} Entorno virtual activado"

# Nota: el generador de audios usa Python 3 (gTTS)
echo "5. (Opcional) Instalar gTTS para el generador (Python 3)"
read -p "¿Instalar con pip3 --user? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    if command -v pip3 &> /dev/null; then
        pip3 install --user gtts && echo -e "${GREEN}✓${NC} gTTS instalado para Python 3"
    else
        echo -e "${YELLOW}!${NC} pip3 no encontrado. Puedes instalar con: sudo apt install python3-pip"
        echo "Luego: python3 -m pip install --user gtts"
    fi
fi

# Verificar AVBin
echo "6. Verificando AVBin (para soporte de música)..."
if [ -f "/usr/lib/libavbin.so" ] || [ -f "/usr/local/lib/libavbin.so" ]; then
    echo -e "${GREEN}✓${NC} AVBin encontrado"
else
    echo -e "${YELLOW}!${NC} AVBin no encontrado"
    echo "AVBin proporciona soporte de música (opcional)"
    echo "Para instalarlo, sigue las instrucciones en extraReadme.txt"
    echo "O descarga desde: http://code.google.com/p/avbin/"
fi

# Crear carpeta para audios en español
echo "7. Creando carpeta para audios en español..."
mkdir -p res/sounds/letras-espanol
echo -e "${GREEN}✓${NC} Carpeta creada: res/sounds/letras-espanol/"

# Hacer ejecutables los scripts
chmod +x crear_audios_espanol.py
chmod +x brainworkshop.pyw

echo ""
echo "=========================================="
echo -e "${GREEN}¡Configuración completada!${NC}"
echo "=========================================="
echo ""
echo "Próximos pasos:"
echo ""
echo "1. GENERAR AUDIOS EN ESPAÑOL (usa Python 3):"
echo "   ${YELLOW}python3 crear_audios_espanol.py${NC}"
echo ""
echo "2. EJECUTAR BRAIN WORKSHOP:"
echo "   ${YELLOW}./run.sh${NC}"
echo "   O manualmente:"
echo "   ${YELLOW}source venv/bin/activate${NC}"
echo "   ${YELLOW}python brainworkshop.pyw${NC}"
echo ""
echo "3. CONFIGURAR (después de ejecutar por primera vez):"
echo "   Edita: ${YELLOW}data/config.ini${NC}"
echo "   Cambia: ${YELLOW}AUDIO1_SETS = ['letras-espanol']${NC}"
echo ""
echo "4. DESACTIVAR ENTORNO VIRTUAL (cuando termines):"
echo "   ${YELLOW}deactivate${NC}"
echo ""
echo "Para más información, lee: GUIA_PERSONALIZACION_ESPANOL.md"
echo ""
