# Pulpo data management system

Tools to admin pulpo data


1. Use `pulpo_get_reportes()` to download all needed reports from zoho creator

2. Clean invoice and gastos data using `pulpo_clean_gastos()` and `pulpo_clean_invoices()`

3. Create libros de gastos e ingresos with `create_libros_gastos()` and `create_libros_ingresos()`

#Example

```{r eval=FALSE}

library(zohor)
library(httr)
library(jsonlite)
library(glue)
library(tidyverse)
library(lubridate)
library(rio)
library(openxlsx)

dir_libros = "C:/Users/andre/Dropbox/Pulpo/06 Hacienda"


#download relevant reports from zoho creator
reportes = pulpo_get_reportes(zoho_password = "xxxxx@",
                              zoho_token = "xxxxxxxxxxxx")




#clean invoice data (revisar comentario de invoice)
clean_invoice = pulpo_clean_invoices(db = reportes$invoices, year = 2021)



#clean gastos
clean_gastos = pulpo_clean_gastos(db = reportes$gastos, db_receptores =  reportes$receptores,year = 2021)


#create and export libro de gatos in xlsx
create_libro_gastos(db_gastos =clean_gastos,
                    dir_libros = dir_libros,
                    year = 2021,
                    users = c("Andres", "Martina", "Pulpo"))



#create and export libro de ingresos in xlsx format
create_libro_ingresos(db_ingresos = clean_invoice,
                      dir_libros = dir_libros,
                      year = 2021)
                      
```
