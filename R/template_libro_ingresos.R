#' Template for libro de ingresos
#' @param db_ingresos A tibble. Clean version of ingresos. It is returned by \code{pulpo_get_reportes()}
#' @param exfile A string. Drectory to save libro de gastos. Must be a .xlsx
#' @param year A number. Year of the libro

template_libro_ingresos <- function(db_ingresos, exfile, year, ...){



  #create totals
  #totals
  base_euros <- str_remove_all(db_ingresos$Base_Imponible, ",") %>%
    as.numeric()


  cobro_euros <- str_remove_all(db_ingresos$Cobro, ",") %>%
    as.numeric()

  total_base_euros <- sum(base_euros, na.rm = T)
  total_cobro <- sum(cobro_euros, na.rm = T)

  total_cambio_cobro <- prettyNum(total_cobro - total_base_euros, big.mark = ",")

  total_base_euros <- prettyNum(total_base_euros, big.mark = ",")
  total_cobro <- prettyNum(total_cobro, big.mark = ",")


  #update values of report for better presentation
  db_ingresos <- db_ingresos %>%
    mutate(across(c(Base_Imponible, Total_Factura, Liquido,
                    Cambio_en_cobro, Cobro), function(x){prettyNum(x, big.mark = ",")}),
           Cambio_en_cobro = case_when(Moneda_de_Factura == "EURO" ~ "No Aplica",
                                       T ~ Cambio_en_cobro),
           across(c(IVA, Retencion_IRPPF), function(x){paste0(x, '%')})

    )


  names(db_ingresos) <- str_replace_all(names(db_ingresos), "_", " ")








  ##define syles --------------------------------------------------------------
  style_title <- createStyle(fontSize = 10,
                             fontName = "Arial",
                             halign = 'center',
                             wrapText = T,
                             #fgFill = color_header,
                             valign = "top",
                             #border = "TopBottomLeftRight",
                             fontColour = "black",
                             borderColour = "#FFFFFF",
                             textDecoration = "bold")


  style_header <- createStyle(fontSize = 9,
                              fontName = "Arial",
                              halign = 'center',
                              wrapText = T,
                              #fgFill = color_header,
                              valign = "center",
                              border = "TopBottomLeftRight",
                              borderStyle = 'thick',
                              fontColour = "black",
                              borderColour = "black",
                              textDecoration = "bold")

  style_content <- createStyle(fontSize = 9,
                               fontName = "Arial",
                               halign = 'left',
                               wrapText = T,
                               #fgFill = color_header,
                               valign = "center",
                               border = "TopBottomLeftRight",
                               fontColour = "black",
                               borderColour = "black")






  ## Create libro de ingresos ----------------------------------------------------
  wb <-createWorkbook()

  ## add sheetname ingresos ------------------------------------------------------
  addWorksheet(wb, sheetName = "ingresos", zoom = 95, orientation = 'portrait')


  # Define Column widths --------------------------------------------------------
  setColWidths(wb,  sheet="ingresos", cols=c(1,2), widths = 11) ## set column width for row names column
  setColWidths(wb,  sheet="ingresos", cols=c(3, ncol(db_ingresos)), widths = 33)
  setColWidths(wb,  sheet="ingresos", cols=c(4,5), widths = 13)
  setColWidths(wb,  sheet="ingresos", cols=c(9,10,13), widths = 10)


  #Define title of the sheet ------------------------------------------------------
  writeData(wb, sheet = 'ingresos', startRow = 2, startCol = 1, paste("Libro de Ingresos", year)) # year is define in the set_up.R
  mergeCells(wb, "ingresos", cols = 1:ncol(db_ingresos), rows = 2)
  addStyle(wb,sheet = "ingresos",style_title,rows =2,cols = 1:ncol(db_ingresos), gridExpand = T) #Style_title is define in styles.R

  #Define header of table -------------------------------------------------------
  header = names(db_ingresos)


  for(i in 1:length(header)) {
    writeData(wb,sheet = "ingresos",startRow = 3, startCol = i, header[i]) #write data into the headers
    addStyle(wb,sheet = "ingresos",style_header,rows =3,cols = 1:ncol(db_ingresos), gridExpand = T)
  }

  #Fiil table with content -------------------------------------------------------

  writeData(wb,sheet = "ingresos",startRow = 4, startCol = 1, db_ingresos, colNames = F)

  rows_until = nrow(db_ingresos) +3 #last row of table
  addStyle(wb,sheet = "ingresos",style_content,rows =4:rows_until,cols = 1:ncol(db_ingresos), gridExpand = T)


  # row of totals
  rows_totales = rows_until + 2



  writeData(wb,sheet = "ingresos",startRow = rows_totales, startCol = 1, "TOTAL", colNames = F) #total
  writeData(wb,sheet = "ingresos",startRow = rows_totales, startCol = 5, total_base_euros, colNames = F) #total

  writeData(wb,sheet = "ingresos",startRow = rows_totales, startCol = 13, total_cambio_cobro, colNames = F) #total
  writeData(wb,sheet = "ingresos",startRow = rows_totales, startCol = 14, total_cobro, colNames = F) #total


  addStyle(wb,sheet = "ingresos",style_header,rows =rows_totales,cols = 1:ncol(db_ingresos), gridExpand = T)

  #Save workbook ----------------------------------------------------------------
  saveWorkbook(wb, file = exfile, overwrite = T) # exfile ingresos is defined in set_up.R


  message("Libro de ingresos esta READY!")
}
