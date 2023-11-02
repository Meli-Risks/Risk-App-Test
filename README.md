 
# RISK-APP-TEST

## Prerequisitos

Asegúrate de tener instalado Gradle en tu sistema. Si no lo tienes, puedes descargarlo e instalarlo desde la página oficial de Gradle.

## Ejecución de pruebas con Karate

Este proyecto utiliza Karate para realizar pruebas. Para ejecutar las pruebas, sigue estos pasos:

1. Abre una terminal.
2. Navega al directorio raíz del proyecto.
3. Ejecuta el siguiente comando:

    ```bash
    gradle test
    ```

4. En la carpeta build se generarán los siguientes reportes: 

    - Carpeta reports. Incluye un reporte general en html.
    - Carpeta karate-reports. Incluye reporte resumen y reportes detallados de cada una de las funcionalidades.

    En la carpeta success-reports se encuentra un ejemplo de los reportes generados tras ejecutar estos tests.
