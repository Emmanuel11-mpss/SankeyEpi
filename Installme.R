# 1. Definir la lista exacta de paquetes requeridos para la app
paquetes_requeridos <- c(
  "shiny",
  "networkD3",
  "readxl",
  "dplyr",
  "htmlwidgets",
  "webshot",
  "RColorBrewer",
  "viridis",
  "colourpicker",
  "bslib",     # NUEVO: Para la interfaz moderna
  "bsicons"    # NUEVO: Para los iconos vectoriales
)

# 2. Identificar qué paquetes NO están instalados actualmente en la computadora
paquetes_faltantes <- paquetes_requeridos[!(paquetes_requeridos %in% installed.packages()[, "Package"])]

# 3. Instalar solo los paquetes que faltan (incluyendo sus dependencias)
if (length(paquetes_faltantes) > 0) {
  message("Instalando paquetes faltantes: ", paste(paquetes_faltantes, collapse = ", "))
  install.packages(paquetes_faltantes, dependencies = TRUE)
} else {
  message("Todos los paquetes de R requeridos ya están instalados.")
}

# 4. Configuración especial para webshot (Instalación de PhantomJS para PNG/PDF)
message("Verificando el motor de renderizado PhantomJS...")
library(webshot)

# Si PhantomJS no está instalado, forzamos su instalación
if (!webshot::is_phantomjs_installed()) {
  message("Instalando PhantomJS (necesario para exportar gráficos en alta calidad)...")
  webshot::install_phantomjs(force = TRUE)
  message("PhantomJS instalado correctamente.")
} else {
  message("PhantomJS ya se encuentra configurado en este equipo.")
}
message("¡Configuración completada! Tu entorno está 100% listo para correr la aplicación Shiny.")
#solo en caso de que no haya sido exitosa la instalación de networkD3 y igraph
#Congelar el tiempo en el repositorio de Posit (13-Oct-2023)
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2023-10-13"))
#Vuelve a corre el codigo anterior solo en caso de que no se hayan instalado los paquetes mencionados
