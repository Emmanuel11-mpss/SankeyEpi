#App para facilitar la creacion de diagramas Shinny
#Autor: Emmanuel Illescas-Aparicio
# Cargar librerías necesarias
library(shiny)
library(networkD3)
library(readxl)
library(dplyr)
library(htmlwidgets)
library(webshot)
library(RColorBrewer) 
library(viridis)      
library(colourpicker) 
library(bslib)        
library(bsicons)      

# Nota: Asegúrate de haber ejecutado webshot::install_phantomjs() al menos una vez
webshot::install_phantomjs(force = TRUE)

# Definir la Interfaz de Usuario Moderna (UI con bslib)
ui <- page_sidebar(
  # Tema visual moderno y limpio
  theme = bs_theme(version = 5, preset = "lumen", primary = "#2C3E50"),
  title = "SankeyEpi",
  
  # Barra lateral con acordeones organizados
  sidebar = sidebar(
    width = 350,
    
    accordion(
      id = "opciones_sidebar",
      multiple = TRUE,
      
      # 1. Panel de Datos
      accordion_panel(
        title = "1. Carga de Datos",
        icon = bs_icon("file-earmark-spreadsheet"),
        fileInput("file_sankey", "Sube tu archivo Excel (.xlsx)", accept = c(".xlsx")),
        helpText("Requiere dos hojas nombradas: 'Links' y 'Nodes'.")
      ),
      
      # 2. Panel de Diseño y Colores
      accordion_panel(
        title = "2. Diseño y Colores",
        icon = bs_icon("palette"),
        selectInput("palette_choice", "Selecciona la Paleta:",
                    choices = c("Original",
                                "Viridis (Apto daltonismo)",
                                "RColorBrewer (Set3)",
                                "RColorBrewer (Spectral)",
                                "RColorBrewer (Pasteles)",
                                "Personalizado")),
        # Contenedor dinámico de colores personalizados
        uiOutput("custom_colors_ui")
      ),
      
      # 3. Panel de Texto (Estándares de Journals)
      accordion_panel(
        title = "3. Formato de Texto",
        icon = bs_icon("type"),
        selectInput("font_family", "Tipografía:",
                    choices = c("Arial" = "Arial", 
                                "Helvetica" = "Helvetica", 
                                "Times New Roman" = "Times New Roman", 
                                "Garamond" = "Garamond",
                                "Calibri" = "Calibri",
                                "Courier New" = "Courier New")),
        numericInput("font_size", "Tamaño de Letra:", 
                     value = 14, min = 8, max = 32, step = 1),
        checkboxGroupInput("font_style", "Estilo de Fuente:",
                           choices = c("Negrita", "Itálica"),
                           selected = "Itálica"),
        selectInput("text_pos", "Posición del Texto:",
                    choices = c("Automático (Recomendado)", 
                                "Izquierda (Antes del nodo)", 
                                "Derecha (Después del nodo)"))
      ),
      
      # 4. Panel de Exportación
      accordion_panel(
        title = "4. Exportar Gráfico",
        icon = bs_icon("download"),
        # Clases de Bootstrap para hacer los botones anchos y de diferentes colores
        downloadButton("download_html", "HTML interactivo", class = "btn btn-primary w-100 mb-2"),
        downloadButton("download_png", "PNG (Alta Calidad)", class = "btn btn-outline-secondary w-100 mb-2"),
        downloadButton("download_pdf", "Documento PDF", class = "btn btn-outline-secondary w-100")
      )
    )
  ),
  
  # Panel Principal (Main) con Tarjeta (Card)
  card(
    full_screen = TRUE, # Permite expandir el gráfico a pantalla completa
    card_header(
      class = "bg-dark text-white",
      bs_icon("diagram-3"), " Visualización de la Red"
    ),
    card_body(
      # Ocupará el 100% de la tarjeta de forma responsiva
      sankeyNetworkOutput("sankey_plot", width = "100%", height = "100%")
    )
  )
)

# Definir la lógica del Servidor (Server)
server <- function(input, output, session) {
  
  # 1. Expresión reactiva para leer y procesar los datos
  sankey_data <- reactive({
    req(input$file_sankey)
    
    ruta_archivo <- input$file_sankey$datapath
    links <- read_excel(ruta_archivo, sheet = "Links")
    nodes <- read_excel(ruta_archivo, sheet = "Nodes")
    
    # Verificar consistencia básica
    if(!all(links$source %in% nodes$name) | !all(links$target %in% nodes$name)) {
      showNotification("Error: Hay nodos en 'Links' que no existen en 'Nodes'.", type = "error")
      return(NULL)
    }
    
    # Convertir nombres a índices (REQUERIDO por networkD3)
    links$IDsource <- match(links$source, nodes$name) - 1
    links$IDtarget <- match(links$target, nodes$name) - 1
    
    list(links = links, nodes = nodes)
  })
  
  # Generar selectores dinámicos
  output$custom_colors_ui <- renderUI({
    req(input$palette_choice == "Personalizado")
    datos <- sankey_data()
    req(datos)
    
    grupos_unicos <- unique(c(datos$nodes$group, datos$links$link_group))
    grupos_unicos <- grupos_unicos[!is.na(grupos_unicos)]
    colores_defecto <- viridis::viridis(length(grupos_unicos))
    
    lapply(seq_along(grupos_unicos), function(i) {
      grupo <- grupos_unicos[i]
      colourpicker::colourInput(
        inputId = paste0("color_", grupo),
        label = paste("Color:", grupo),
        value = colores_defecto[i]
      )
    })
  })
  
  # 2. Expresión reactiva para generar el objeto Sankey
  generate_sankey <- reactive({
    datos <- sankey_data()
    req(datos)
    
    links <- datos$links
    nodes <- datos$nodes
    palette_choice <- input$palette_choice
    
    # --- Lógica de Paletas ---
    if (palette_choice == "Original") {
      node_colour <- '
      d3.scaleOrdinal()
      .domain([
      "Host","Leish1","Leish2","Leish3","Leish4",
      "Leish5","Leish6","Leish7","Leish8","Leish9","Vector",
      "Leish1-Host","Leish2-Host","Leish3-Host","Leish4-Host",
      "Leish5-Host","Leish6-Host","Leish7-Host","Leish8-Host","Leish9-Host",
      "Leish2-Vector","Leish5-Vector","Leish6-Vector",
      "Host-Host","Vector-Vector"
      ])
      .range([
      "#FFFFCC","#FF99FF","#FF3300","#CCFFFF","#CC99FF",
      "#0066CC","#006600","#00FF99","#FFFF99","#FF9900","#996633",
      "#FF99FF","#FF3300","#CCFFFF","#CC99FF",
      "#0066CC","#006600","#00FF99","#FFFF99","#FF9900",
      "#FF3300","#0066CC","#006600",
      "#CCCCCC","#999999"
      ])
      '
    } else {
      grupos_unicos <- unique(c(nodes$group, links$link_group))
      grupos_unicos <- grupos_unicos[!is.na(grupos_unicos)] 
      n_colores <- length(grupos_unicos)
      
      if (palette_choice == "Viridis (Apto daltonismo)") {
        colores_hex <- viridis::viridis(n_colores)
      } else if (palette_choice == "RColorBrewer (Set3)") {
        colores_hex <- colorRampPalette(RColorBrewer::brewer.pal(8, "Set3"))(n_colores)
      } else if (palette_choice == "RColorBrewer (Spectral)") {
        colores_hex <- colorRampPalette(RColorBrewer::brewer.pal(11, "Spectral"))(n_colores)
      } else if (palette_choice == "RColorBrewer (Pasteles)") {
        colores_hex <- colorRampPalette(RColorBrewer::brewer.pal(9, "Pastel1"))(n_colores)
      } else if (palette_choice == "Personalizado") {
        colores_hex <- sapply(grupos_unicos, function(g) {
          color_seleccionado <- input[[paste0("color_", g)]]
          if(is.null(color_seleccionado)) return("#CCCCCC") 
          return(color_seleccionado)
        })
      }
      
      js_domain <- paste0('"', grupos_unicos, '"', collapse = ",")
      js_range <- paste0('"', colores_hex, '"', collapse = ",")
      node_colour <- paste0('d3.scaleOrdinal().domain([', js_domain, ']).range([', js_range, '])')
    }
    
    # Crear Sankey 
    p <- sankeyNetwork(
      Links = links,
      Nodes = nodes,
      Source = "IDsource",
      Target = "IDtarget",
      Value = "value",
      NodeID = "name",
      NodeGroup = "group",
      LinkGroup = "link_group",
      colourScale = node_colour,
      fontFamily = input$font_family,   
      fontSize = input$font_size,       
      sinksRight = FALSE,
      nodeWidth = 15 
    )
    
    # Lógica dinámica JS
    js_font_weight <- if ("Negrita" %in% input$font_style) "bold" else "normal"
    js_font_style <- if ("Itálica" %in% input$font_style) "italic" else "normal"
    
    js_text_anchor <- ""
    if (input$text_pos == "Izquierda (Antes del nodo)") {
      js_text_anchor <- 'text_nodes.attr("x", -6).style("text-anchor", "end");'
    } else if (input$text_pos == "Derecha (Después del nodo)") {
      js_text_anchor <- 'text_nodes.attr("x", 21).style("text-anchor", "start");' 
    }
    
    codigo_js <- paste0('
      function(el) {
        var text_nodes = d3.select(el).selectAll(".node text");
        text_nodes.style("font-weight", "', js_font_weight, '");
        text_nodes.style("font-style", "', js_font_style, '");
        ', js_text_anchor, '
        d3.select(el).selectAll(".link").style("stroke-opacity", 0.4);
      }
    ')
    
    p <- onRender(p, codigo_js)
    return(p)
  })
  
  # 3. Renderizar el Sankey
  output$sankey_plot <- renderSankeyNetwork({
    generate_sankey()
  })
  
  # 4. Exportaciones
  output$download_html <- downloadHandler(
    filename = function() { "Sankey_Interactivo.html" },
    content = function(file) {
      saveWidget(generate_sankey(), file = file, selfcontained = TRUE)
    }
  )
  
  output$download_png <- downloadHandler(
    filename = function() { "Figura_Sankey.png" },
    content = function(file) {
      temp_html <- tempfile(fileext = ".html")
      saveWidget(generate_sankey(), temp_html, selfcontained = TRUE)
      webshot(temp_html, file = file, vwidth = 3000, vheight = 2000)
    }
  )
  
  output$download_pdf <- downloadHandler(
    filename = function() { "Figura_Sankey.pdf" },
    content = function(file) {
      temp_html <- tempfile(fileext = ".html")
      saveWidget(generate_sankey(), temp_html, selfcontained = TRUE)
      webshot(temp_html, file = file, vwidth = 7000, vheight = 4400)
    }
  )
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)