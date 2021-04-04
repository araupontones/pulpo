#' Clean invoices report
#'
#' Cleans invoice report to create relevant variables for \code{libro_de_ingresos}
#' @param db A tibble. Data base with the raw version of the invoice report. To get this
#' report, run \code{pulpo_get_reportes()}
#' @param year A number. Year for which the libro de gastos is to be generated
#' @return A tibble with all the relevant variables to create libro de gastos



pulpo_clean_invoices = function(db = invoices,
                                year,
                                ...){

  #clean and keep relevant variables
  invoices_filter = db %>%
    #filter invoices relevant for this year ---------------------------------
  filter(year(dmy(invoice_date)) == year,
         invoice_paid != "Not sent") %>%
    mutate(
      invoice_expenses_euros = case_when(invoice_expenses_euros == "" ~ 0,
                                         T ~ as.numeric(invoice_expenses_euros)),
      across(c("invoice_total_euros",
                    "invoice_amount_transfered",
                    "invoice_expenses_euros",
                    "invoice_services_euros"), as.numeric),
           User = str_trim(User, side = "both"))




  ##data for table
  invoices_clean = invoices_filter %>%
    #create variables relevant for libro de ingresos -----------------------------
  mutate(
    Factura = Invoice_ID ,
    Fecha =  dmy(invoice_date),
    Cliente = invoice_client,
    VAT = invoice_client_vat,
    Base_Imponible  = invoice_services_euros + invoice_expenses_euros - invoice_sales_tax + invoice_sales_retention,
    IVA = invoice_tax ,
    Cuota_IVA = invoice_sales_tax,
    Total_Factura = Base_Imponible + invoice_sales_tax,
    Retencion_IRPPF  = invoice_retention,
    Cuota_de_Retencion = invoice_sales_retention,
    Liquido = Base_Imponible + Cuota_IVA - Cuota_de_Retencion,
    Moneda_de_Factura = invoice_currency,
    Cambio_en_cobro = invoice_amount_transfered - Liquido,
    Cobro = invoice_amount_transfered,
    Comentario = Projects.Comment_for_invoice_book
  ) %>%
    #keep relevant variables ----------------------------------------------------
  select(Factura,
         Fecha,
         Cliente,
         VAT,
         Base_Imponible,
         IVA,
         Cuota_IVA,
         Total_Factura,
         Retencion_IRPPF,
         Cuota_de_Retencion,
         Liquido,
         Moneda_de_Factura ,
         Cambio_en_cobro ,
         Cobro,
         Comentario,
         Mode,
         User
  ) %>%

    arrange(Fecha, Factura) %>%
    mutate(Fecha = format(Fecha, "%d/%m/%Y"))

  return(invoices_clean)
  message("Clean invoices ran!")
}
