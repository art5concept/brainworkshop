#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Script para generar audios de letras en español para Brain Workshop
Usa gTTS (Google Text-to-Speech) para crear los archivos de audio

Uso:
    1. Instala gTTS: pip install gtts
    2. Ejecuta: python crear_audios_espanol.py
    3. Los archivos se crearán en res/sounds/letras-espanol/

Alternativas si no tienes internet o prefieres otro TTS:
    - Usa pyttsx3 (offline): pip install pyttsx3
    - Graba tu propia voz con Audacity
    - Usa espeak: espeak -v es "letra" -w output.wav
"""

import os
import sys

# Compatibilidad input en Py2/Py3
try:
    input  # type: ignore[name-defined]
except NameError:  # Python 2
    input = raw_input  # type: ignore[assignment]

def crear_con_gtts():
    """Crea audios usando Google TTS (requiere internet)"""
    try:
        from gtts import gTTS
    except ImportError:
        print("Error: gTTS no está instalado.")
        print("Instálalo con: pip install gtts")
        return False
    
    # Letras que usa Brain Workshop por defecto
    letras_basicas = ['c', 'h', 'k', 'l', 'q', 'r', 's', 't']
    
    # Alfabeto completo (opcional)
    alfabeto_completo = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                        'k', 'l', 'm', 'n', 'ñ', 'o', 'p', 'q', 'r', 's',
                        't', 'u', 'v', 'w', 'x', 'y', 'z']
    
    print("¿Qué letras quieres generar?")
    print("1. Solo las 8 letras básicas (c,h,k,l,q,r,s,t)")
    print("2. Todo el alfabeto español (a-z + ñ)")
    
    opcion = input("Elige opción (1 o 2): ").strip()
    
    if opcion == "2":
        letras = alfabeto_completo
    else:
        letras = letras_basicas
    
    # Carpeta de destino
    output_dir = 'res/sounds/letras-espanol'
    
    # Crear carpeta si no existe
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print("Carpeta creada: " + output_dir)
    
    print("\nGenerando audios...")
    print("-" * 50)
    
    for letra in letras:
        try:
            print("Procesando: " + letra)
            
            # Crear audio con pronunciación española
            # slow=False para velocidad normal
            tts = gTTS(text=letra, lang='es', slow=False)
            
            # Guardar como mp3
            output_file = os.path.join(output_dir, letra + '.mp3')
            tts.save(output_file)
            
            print("  ✓ Guardado: " + output_file)
            
        except Exception as e:
            print("  ✗ Error con '" + letra + "': " + str(e))
    
    print("-" * 50)
    print("\n¡Completado!")
    print("Archivos creados en: " + output_dir)
    print("\nPróximos pasos:")
    print("1. Edita data/config.ini")
    print("2. Cambia AUDIO1_SETS = ['letras-espanol']")
    print("3. Ejecuta: python brainworkshop.pyw")
    
    return True


def crear_con_pyttsx3():
    """Crea audios usando pyttsx3 (offline, no requiere internet)"""
    try:
        import pyttsx3
    except ImportError:
        print("Error: pyttsx3 no está instalado.")
        print("Instálalo con: pip install pyttsx3")
        return False
    
    letras_basicas = ['c', 'h', 'k', 'l', 'q', 'r', 's', 't']
    output_dir = 'res/sounds/letras-espanol'
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # Inicializar engine
    engine = pyttsx3.init()
    
    # Configurar voz en español (puede variar según el sistema)
    voices = engine.getProperty('voices')
    for voice in voices:
        if 'spanish' in voice.name.lower() or 'español' in voice.name.lower():
            engine.setProperty('voice', voice.id)
            break
    
    # Velocidad de habla (palabras por minuto)
    engine.setProperty('rate', 150)
    
    print("\nGenerando audios con pyttsx3...")
    print("-" * 50)
    
    for letra in letras_basicas:
        try:
            print("Procesando: " + letra)
            output_file = os.path.join(output_dir, letra + '.wav')
            engine.save_to_file(letra, output_file)
            print("  ✓ Guardado: " + output_file)
        except Exception as e:
            print("  ✗ Error con '" + letra + "': " + str(e))
    
    engine.runAndWait()
    
    print("-" * 50)
    print("¡Completado!")
    
    return True


def crear_con_espeak():
    """Crea audios usando espeak (línea de comandos)"""
    import subprocess
    
    # Verificar si espeak está instalado
    try:
        subprocess.check_output(['which', 'espeak'])
    except:
        print("Error: espeak no está instalado.")
        print("Instálalo con: sudo apt-get install espeak")
        return False
    
    letras_basicas = ['c', 'h', 'k', 'l', 'q', 'r', 's', 't']
    output_dir = 'res/sounds/letras-espanol'
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    print("\nGenerando audios con espeak...")
    print("-" * 50)
    
    for letra in letras_basicas:
        try:
            print("Procesando: " + letra)
            output_file = os.path.join(output_dir, letra + '.wav')
            
            # Ejecutar espeak
            # -v es = voz española
            # -w = escribir a archivo WAV
            subprocess.call(['espeak', '-v', 'es', '-w', output_file, letra])
            
            print("  ✓ Guardado: " + output_file)
        except Exception as e:
            print("  ✗ Error con '" + letra + "': " + str(e))
    
    print("-" * 50)
    print("¡Completado!")
    
    return True


def main():
    print("=" * 50)
    print("Generador de Audios en Español - Brain Workshop")
    print("=" * 50)
    print("\nElige el método para generar los audios:\n")
    print("1. gTTS (Google TTS) - Requiere internet, mejor calidad")
    print("2. pyttsx3 - Offline, calidad media")
    print("3. espeak - Offline, sintético pero funcional")
    print("4. Salir")
    
    opcion = input("\nElige opción (1-4): ").strip()
    
    if opcion == "1":
        crear_con_gtts()
    elif opcion == "2":
        crear_con_pyttsx3()
    elif opcion == "3":
        crear_con_espeak()
    elif opcion == "4":
        print("Saliendo...")
        sys.exit(0)
    else:
        print("Opción no válida")
        sys.exit(1)


if __name__ == "__main__":
    main()
