# Instalación de Brain Workshop en Linux

Este directorio contiene los archivos necesarios para instalar Brain Workshop en su sistema.

## Opción 1: Instalación directa (sudo make install)

Si desea instalar el juego directamente en su sistema:

1.  Asegúrese de tener `python2` instalado.
2.  Ejecute el siguiente comando en la terminal:

    ```bash
    sudo make install
    ```

Esto instalará el juego en `/opt/brainworkshop` y creará un acceso directo en el menú de aplicaciones.

Para desinstalar:
```bash
sudo make uninstall
```

## Opción 2: Crear paquete .deb (Debian/Ubuntu/Mint)

Si prefiere crear un paquete instalable `.deb`:

1.  Ejecute el script de construcción:

    ```bash
    ./build_deb.sh
    ```

2.  Esto generará un archivo `brainworkshop_4.8.4_all.deb`.
3.  Instale el paquete con:

    ```bash
    sudo dpkg -i brainworkshop_4.8.4_all.deb
    sudo apt-get install -f  # Para corregir dependencias si es necesario
    ```

## Notas

- El juego requiere `python2` y la librería `pyglet` (versión 1.4.x recomendada).
- Si el juego no inicia por falta de librerías, asegúrese de instalarlas con `pip2 install pyglet==1.4.10`.
