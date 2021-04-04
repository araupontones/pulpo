#' Clean gastos report and prepare variables for Libro de gastos
#'
#' @param db A tibble. Raw data of gastos report as it is exported from Zoho
#' @param db_receptores A tibble. Raw data of receptores report as it is exported from Zoho
#' @param year A number. year for which the report is to be created
#' @return A tibble, with all the variables for libro de gastos


pulpo_clean_gastos = function(db, db_receptores,year, ...){


  #clean names of variables to make it consistent with report
  names(db) <- str_remove(names(db), "gastos_") %>%
    str_replace_all(., "_"," ") %>%
    str_to_title()

  gastos_clean = db %>%
    #format relevant variables
    mutate(Fecha = as_date(dmy_hms(Fecha)),
           Total = Liquido,
           Users = str_trim(Users, side = "both")) %>%

    #filter for relevant year ------------------------------------------------------------
    filter(year(Fecha) == year,
           `Tipo De Gasto` != "") %>%
    #get receptor NIF -----------------------------------------------------------
  left_join(
    select(reportes$receptores,c("Receptor", "Receptor_NIF")),  by = c("Receptores"="Receptor")
  ) %>%
    #order variables as in the book --------------------------------------------
  select(
    Factura, Fecha, Receptores, Receptor_NIF, `Base Imponible`,
    Iva, `Cuota Iva`, `Total Factura`,Retencion, `Cuota Retencion`,
    `Tipo De Gasto`, Liquido, Total ,Comentarios,  Users
  ) %>%

    #define a column for each category -------------------------------------------
  pivot_wider(
    names_from = "Tipo De Gasto",
    values_from = "Total",
    values_fill = NULL
  ) %>%
    #arrange variables
    relocate(Receptor_NIF, .after = Receptores) %>%
    relocate(Liquido, Comentarios, Users, .after = last_col()) %>%


    #rename for consistency with Libros
    rename(`Nombre y Apellidos o Razon Social` = Receptores,
           `NIF / NIE / VAT` = Receptor_NIF,
           `IVA %` = Iva,
           `Cuota IVA` = `Cuota Iva`
           #`Total` = Total Factura` - `Cuota Retencion
    ) %>%
    arrange(Fecha)


  return(gastos_clean)
  message("Clean gastos ran!")



}







