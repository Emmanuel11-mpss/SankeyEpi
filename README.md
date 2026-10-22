# SankeyEpi
SankeyEpi es una herramienta interactiva diseñada para visualizar conexiones de flujo, asignando tamaños proporcionales a cada una de las lineas que forman el diagrama Sankey.
En este caso este codigo lo desarrolle para representar graficamenta la conexión de parasito - vector - hospederos de forma lineal, sin embargo puede usarse en otras areas para representar diversos procesos (como el avance del tiempo, el ciclo de vida de un organismo o las etapas sucesivas de un proceso industrial).
Este tipo de diagramas surge en el siglo XIX, concebidos originariamente por el ingeniero civil irlandés Matthew Henry Phineas Riall Sankey. Su propósito inicial fue ilustrar de manera diáfana la eficiencia energética y las pérdidas termodinámicas inherentes a las máquinas de vapor reales frente a los modelos teóricos ideales. 
Guía de uso en español
Autor: Emmanuel Illescas Aparicio
Declaración de IA: Use Gemini para optimizar la interfaz interativa
Fecha: Octubre 2026
Prepara el ambiente
Antes de usar SankeyEpi verifica con el archivo de código "Installme" que compartí vienen todos los paquetes requeridos para su funcionamiento, úsalo para instalar tus dependencias faltantes y preparar el ambiente.
Para aprender a usar la herramienta, utilizaremos el archivo de prueba "sankey_didactico.xlsx"

1. Estructura de los Datos (El archivo Excel)

La aplicación requiere un archivo Excel con exactamente dos hojas: "Nodes" y "Links". El archivo "sankey_didactico.xlsx" es un ejemplo de como debe estar estructurado el archivo.

Hoja 1: "Links" (Los Flujos)
Define cómo se conectan los actores y con qué intensidad. Los explico a continuación:
-source: El origen del flujo (ej. Leishmania mexicana). Debe estar escrito idénticamente a como aparece en la hoja Nodes.
-target: El destino del flujo (ej. Diptera). También debe coincidir con la hoja Nodes.
-value: Un número que define el grosor de la línea (ej. 50). Representa la incidencia o frecuencia de interacción. Este numero lo puedes asignar por frecuencia o proporción.
-link_group: Determina el color de la banda conectora (ej. Leish1-Vector). Según el número de grupos y conexiones son la diversidad de colores que se asignan.

Hoja 2: "Nodes" (Los Actores)
Define a todos los participantes de tu red. Se conforma de los siguientes dos elementos:
-name: El nombre exacto de la especie o grupo (ej. Leishmania mexicana, Diptera, Homo). No dejes espacios en blanco al final de las palabras.
-group: La categoría a la que pertenece (ej. Leish1, Vector, Host). La aplicación usará esta columna para asignar los colores.


2. Pasos para usar la aplicación
a. Cargar el Archivo:
-Abre la aplicación y dirígete al panel lateral izquierdo "1. Carga de Datos".
-Haz clic en "Browse..." y selecciona el archivo "sankey_didactico.xlsx".
-El diagrama aparecerá instantáneamente en el panel central.

2. Personalizar el Diseño (Colores):
-Abre el menú "2. Diseño y Colores".
-Recomendamos usar la paleta de colores "Apto para daltonismo". Esto para garantizar que tu contenido sera legible para todos los lectores.
-Selecciona "Personalizado" si deseas asignar colores específicos para cada vector o hospedero. Se desplegarán selectores para elegir los tonos exactos que exige tu manual de identidad gráfica o revista.
-Si deseas añadir iconos, te recomiendo que después de que descargues el archivo final, usa el editor de pdf de tu elección para añadirlos.

3. Ajustar la Tipografía:
-Abre "3. Formato de Texto".
-Cambia la fuente a tu preferencia, ajusta el tamaño y puedes selecciona "Itálica" para cumplir con las normas de nomenclatura de especies científicas.

4. Exportar para Publicación:
-Dirígete a "4. Exportar Gráfico".
-Utiliza HTML interactivo si deseas compartir el gráfico para una presentación web. Recomiendo que primero descargues este documento.
-Utiliza PNG o PDF para obtener figuras estáticas de alta resolución (hasta 3000px/7000px) listas para insertarse en tu manuscrito.

User Guide in English
Author: Emmanuel Illescas Aparicio
AI Statement: Use Gemini to optimize the interactive interface
Date: October 2026

SankeyEpi is an interactive tool designed to visualize flow connections, assigning proportional sizes to each of the lines that make up the Sankey diagram.
In this case, I developed this code to graphically represent the parasite-vector-host connection in a linear fashion; however, it can be used in other areas to represent various processes (such as the passage of time, the life cycle of an organism, or the successive stages of an industrial process).
This type of diagram emerged in the 19th century, originally conceived by the Irish civil engineer Matthew Henry Phineas Riall Sankey. Its initial purpose was to clearly illustrate the energy efficiency and thermodynamic losses inherent in real steam engines compared to ideal theoretical models.

Set Up Your Environment
Before using SankeyEpi, check the “Installme” code file I shared to ensure it includes all the packages required for the tool to run. Use it to install any missing dependencies and set up your environment.
To learn how to use the tool, we’ll use the sample file “sankey_didactico.xlsx”

1. Data Structure (The Excel File)

The application requires an Excel file with exactly two sheets: “Nodes” and “Links.” The “sankey_didactico.xlsx” file is an example of how the file should be structured.

Sheet 1: “Links” (The Flows)
Defines how the actors are connected and with what intensity. I’ll explain them below:
-source: The origin of the flow (e.g., Leishmania mexicana). It must be written exactly as it appears in the “Nodes” sheet.
-target: The destination of the flow (e.g., Diptera). It must also match the “Nodes” sheet.
-value: A number that defines the line thickness (e.g., 50). It represents the incidence or frequency of interaction. You can assign this number based on frequency or proportion.
-link_group: Determines the color of the connecting line (e.g., Leish1-Vector). The variety of colors assigned depends on the number of groups and connections.

Sheet 2: “Nodes” (The Actors)
Defines all participants in your network. It consists of the following two elements:
-name: The exact name of the species or group (e.g., Leishmania mexicana, Diptera, Homo). Do not leave spaces at the end of words.
-group: The category to which it belongs (e.g., Leish1, Vector, Host). The application will use this column to assign colors.


2. Steps for Using the Application
a. Load the File:
-Open the application and go to the left-hand sidebar labeled "1. Carga de Datos"
-Click “Browse...” and select the file "sankey_didactico.xlsx".
-The diagram will appear instantly in the central panel.

2. Customize the Design (Colors):
-Open the "2. Diseño y Colores" menu.
-We recommend using the "Apto para daltonismo" color palette. This ensures that your content will be readable for all readers.
-Select “Custom” if you want to assign specific colors to each vector or host. Color pickers will appear so you can choose the exact shades required by your brand guidelines or magazine.
-If you want to add icons, I recommend that after you download the final file, you use the PDF editor of your choice to add them.

3. Adjust the Typography:
-Open "3. Formato de Texto"
-Change the font to your preference, adjust the size, and select “Italica” to comply with scientific species nomenclature standards.

4. Export for Publication:
-Go to "4. Exportar Gráfico"
-Use interactive HTML if you want to share the graphic for a web presentation. I recommend that you download this document first.
-Use PNG or PDF to obtain high-resolution static figures (up to 3000px/7000px) ready to be inserted into your manuscript.
