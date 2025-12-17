# Guía de Personalización - Brain Workshop en Español

## 📋 Resumen
Esta guía te explica cómo:
1. Crear un entorno virtual aislado para trabajar sin afectar tu sistema
2. Agregar audios personalizados en español
3. Configurar Brain Workshop para usar tus audios

---

## 🔧 PARTE 1: Configurar Entorno Virtual (Aislado)

### Paso 1: Instalar dependencias del sistema
```bash
# Python 2.5+ (el programa requiere Python 2, no Python 3)
# En Ubuntu/Debian:
sudo apt-get update
sudo apt-get install python2.7 python-pip python-virtualenv

# AVBin (para soporte de música - opcional pero recomendado)
# Descarga desde: http://code.google.com/p/avbin/
# O sigue las instrucciones en extraReadme.txt
```

### Paso 2: Crear entorno virtual
```bash
# Navega al directorio del proyecto
cd /home/felix/Downloads/tmp/dualnback/version4.8.4./brainworkshop

# Crea un entorno virtual con Python 2
virtualenv -p python2.7 venv

# Activa el entorno virtual
source venv/bin/activate

# Tu terminal ahora mostrará (venv) al inicio
```

### Paso 3: Instalar dependencias Python (si son necesarias)
```bash
# El proyecto ya incluye pyglet, pero si necesitas algo más:
# pip install <paquete>

# Para desactivar el entorno cuando termines:
# deactivate
```

---

## 🎵 PARTE 2: Agregar Audios en Español

### Cómo Funciona el Sistema de Sonidos

El programa carga automáticamente todos los archivos de audio (.wav, .mp3, .ogg) desde carpetas en:
```
res/sounds/
├── letters/          ← Letras en inglés (actualmente: c,h,k,l,q,r,s,t)
├── numbers/          ← Números
├── nato/             ← Alfabeto fonético NATO
├── morse/            ← Código morse
├── piano/            ← Notas de piano
├── operations/       ← Operaciones matemáticas
└── corsica-letters/  ← Otro set de letras
```

**Código relevante** (líneas 925-930 en brainworkshop.pyw):
```python
sounds = {}
for k in resourcepaths['sounds'].keys():
    sounds[k] = {}
    for f in resourcepaths['sounds'][k]:
        sounds[k][os.path.basename(f).split('.')[0]] = pyglet.media.load(f, streaming=False)
```

**Lo que hace:**
- Lee el nombre del archivo sin extensión como identificador
- Ejemplo: `a.wav` → identificador 'a'
- Carga el audio en memoria

### Paso a Paso: Crear Audios en Español

#### Opción 1: Carpeta Nueva "letras-espanol"

1. **Crea una nueva carpeta:**
```bash
mkdir res/sounds/letras-espanol
```

2. **Prepara tus archivos de audio:**
   - Necesitas 8 archivos de audio (una para cada letra usada: c, h, k, l, q, r, s, t)
   - Formato recomendado: WAV (44.1 kHz)
   - Otros formatos compatibles: MP3, OGG
   - Nombra los archivos: `c.wav`, `h.wav`, `k.wav`, `l.wav`, `q.wav`, `r.wav`, `s.wav`, `t.wav`

3. **Ejemplo de creación de audios:**
   - Grábate pronunciando cada letra en español
   - Usa software como Audacity (gratuito)
   - O usa text-to-speech en español (por ejemplo, Google TTS, eSpeak, etc.)

4. **Script Python para generar audios con TTS (opcional):**
```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
# crear_audios_espanol.py

"""
Script para generar audios de letras en español usando gTTS
Requiere: pip install gtts
"""

from gtts import gTTS
import os

# Letras que usa Brain Workshop
letras = ['c', 'h', 'k', 'l', 'q', 'r', 's', 't']

# Carpeta de destino
output_dir = 'res/sounds/letras-espanol'
os.makedirs(output_dir, exist_ok=True)

for letra in letras:
    print("Generando audio para: " + letra)
    
    # Crear audio con pronunciación española
    tts = gTTS(text=letra, lang='es', slow=False)
    
    # Guardar como mp3
    output_file = os.path.join(output_dir, letra + '.mp3')
    tts.save(output_file)
    
    print("  Guardado: " + output_file)

print("\n¡Completado! Archivos creados en: " + output_dir)
```

#### Opción 2: Reemplazar la carpeta "letters" existente

1. **Haz backup de los audios originales:**
```bash
cp -r res/sounds/letters res/sounds/letters-original-backup
```

2. **Reemplaza los archivos:**
   - Coloca tus archivos en español en `res/sounds/letters/`
   - Mantén los mismos nombres: c.wav, h.wav, etc.

---

## ⚙️ PARTE 3: Configurar Brain Workshop

### Opción A: Usar tu nueva carpeta "letras-espanol"

Edita el archivo de configuración:
```bash
# Primero ejecuta el programa una vez para generar config.ini
python brainworkshop.pyw

# Luego edita:
nano data/config.ini
```

Busca la línea (aproximadamente línea 250):
```ini
AUDIO1_SETS = ['letters']
```

Cámbiala a:
```ini
AUDIO1_SETS = ['letras-espanol']
```

### Opción B: Crear múltiples sets y elegir en el juego

En `config.ini`:
```ini
# Puedes tener múltiples sets disponibles
AUDIO1_SETS = ['letters', 'letras-espanol', 'nato']
```

Luego en el juego, presiona **S** para seleccionar el set de sonidos.

---

## 🚀 PARTE 4: Ejecutar el Programa

### Con entorno virtual:
```bash
# Asegúrate de estar en el directorio del proyecto
cd /home/felix/Downloads/tmp/dualnback/version4.8.4./brainworkshop

# Activa el entorno virtual
source venv/bin/activate

# Ejecuta el programa
python brainworkshop.pyw

# Cuando termines, desactiva el entorno
deactivate
```

### Sin entorno virtual (no recomendado):
```bash
python brainworkshop.pyw
```

---

## 📝 Notas Adicionales

### Formato de Audio Recomendado
- **Frecuencia de muestreo:** 44.1 kHz
- **Formato:** WAV (sin compresión) o MP3
- **Duración:** 0.5-1.5 segundos por letra
- **Volumen:** Normalizado (todos al mismo nivel)

### Letras Utilizadas
El programa usa 8 letras aleatorias de tu set de sonidos. Actualmente usa:
- c, h, k, l, q, r, s, t

Si quieres más variedad, puedes agregar más archivos de audio (a.wav, b.wav, d.wav, etc.)

### Estructura Completa de Carpetas de Sonidos Posibles
```
res/sounds/
├── letras-espanol/     ← Tu nueva carpeta
│   ├── a.wav
│   ├── b.wav
│   ├── c.wav
│   ├── ... (todas las letras que quieras)
│   └── z.wav
├── numeros-espanol/    ← Opcional: números en español
│   ├── 0.wav
│   ├── 1.wav
│   └── ... 
└── ... (carpetas originales)
```

### Solución de Problemas

**Problema:** No se escucha ningún sonido
- Verifica que AVBin esté instalado correctamente
- Comprueba el formato de tus archivos de audio
- Mira los logs en la terminal

**Problema:** Error al cargar archivos
- Asegúrate de que los nombres de archivo solo contengan letras minúsculas
- No uses caracteres especiales ni espacios
- Verifica que los archivos no estén corruptos

**Problema:** Python no encuentra módulos
- Verifica que el entorno virtual esté activado
- El programa usa Python 2, no Python 3

---

## 🎯 Checklist Rápido

- [ ] Entorno virtual creado y activado
- [ ] AVBin instalado (opcional, para música)
- [ ] Carpeta `res/sounds/letras-espanol/` creada
- [ ] 8 archivos de audio creados (c.wav, h.wav, k.wav, l.wav, q.wav, r.wav, s.wav, t.wav)
- [ ] config.ini editado con `AUDIO1_SETS = ['letras-espanol']`
- [ ] Programa ejecutado y probado

---

## 📚 Referencias

- **Documentación original:** Readme.txt
- **Instrucciones Linux:** extraReadme.txt
- **Configuración:** data/config.ini (se crea al ejecutar por primera vez)
- **Sitio web:** http://brainworkshop.sourceforge.net

---

## 🤝 Contribuir

Si creas un buen set de audios en español, considera compartirlos con la comunidad:
- Foro: http://groups.google.com/group/brain-training
- Email: plhosk@gmail.com, jtoomim@jtoomim.org

¡Buena suerte con tu entrenamiento cerebral en español! 🧠
