# Brain Workshop - Versión en Español 🇪🇸

## 🚀 Inicio Rápido

### 1. Configuración Inicial (solo una vez)
```bash
./setup_espanol.sh
```
Este script:
- ✓ Verifica Python 2
- ✓ Crea un entorno virtual aislado (no afecta tu sistema)
- ✓ Instala dependencias opcionales
- ✓ Crea la carpeta para audios en español

### 2. Generar Audios en Español
```bash
# Usa Python 3 para el generador (gTTS es para Py3)
python3 crear_audios_espanol.py
```
Elige entre:
- **gTTS** (Google TTS) - Mejor calidad, requiere internet
- **pyttsx3** - Offline, calidad media
- **espeak** - Offline, sintético

### 3. Ejecutar el Programa
```bash
./run.sh
```

### 4. Configurar (después de la primera ejecución)
```bash
nano data/config.ini
```
Cambia:
```ini
AUDIO1_SETS = ['letras-espanol']
```

---

## 📖 Documentación Completa

Lee **GUIA_PERSONALIZACION_ESPANOL.md** para:
- Instrucciones detalladas paso a paso
- Cómo grabar tus propios audios
- Solución de problemas
- Personalización avanzada

---

## 📁 Archivos Importantes

- `setup_espanol.sh` - Configuración automática del entorno
- `crear_audios_espanol.py` - Genera audios en español
- `run.sh` - Ejecuta el programa en el entorno virtual
- `GUIA_PERSONALIZACION_ESPANOL.md` - Guía completa en español
- `data/config.ini` - Archivo de configuración (se crea al ejecutar)
- `res/sounds/letras-espanol/` - Carpeta para tus audios

---

## 🎯 Estructura de Audios

Los audios deben estar en formato WAV o MP3:
```
res/sounds/letras-espanol/
├── c.wav (o .mp3)
├── h.wav
├── k.wav
├── l.wav
├── q.wav
├── r.wav
├── s.wav
└── t.wav
```

**Opcional:** Agrega más letras (a-z) para mayor variedad.

---

## ❓ Ayuda

- **Documentación original:** Readme.txt
- **Instrucciones Linux:** extraReadme.txt
- **Sitio web:** http://brainworkshop.sourceforge.net
- **Foro:** http://groups.google.com/group/brain-training

---

## 🛠️ Comandos Útiles

```bash
# Activar entorno virtual manualmente
source venv/bin/activate

# Ejecutar con parámetros personalizados
python brainworkshop.pyw --statsfile mi_progreso.txt

# Desactivar entorno virtual
deactivate

# Reinstalar entorno virtual
rm -rf venv && ./setup_espanol.sh

# Instalar gTTS para el generador (Python 3)
python3 -m pip install --user gtts
```

---

¡Disfruta mejorando tu memoria de trabajo en español! 🧠✨
