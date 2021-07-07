#' Download reports to from zoho creator
#'
#'@param zoho_password A string. Password of araupontones in zoho creator
#'@param zoho_token A string. Token of Zoho creator API of araupontone
#' @return A list with the reports of: \code{invoices}, \code{gastos}, \code{receptores},
#' \code{expenses}


pulpo_get_reportes <-  function(){

#define reports ----------------------------------------------------------------
reports = c("All_Invoices",
            "Gastos_Report",
            "Receptores_Report",
            "All_Expenses",
            "All_Projects")


#define parameters of app -------------------------------------------------------
app <- "pulpo"
report <- "All_Invoices"

refresh_token = "1000.b11df28b89daaeb2df10fa2c43178db6.6f953944b607f0ff366915cb9a770edc"
client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ"
client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6"
base_url = "https://accounts.zoho.com"




#download reports --------------------------------------------------------------

reports_list <- purrr::map(reports, function(x){


  zohor::get_report_bulk(url_app = "https://creator.zoho.com" ,
                         account_owner_name = "araupontones" ,
                         app_link_name = "pulpo",
                         report_link_name = x,
                         access_token = new_token,
                         criteria = "ID != 0",
                         from = 1,
                         client_id = client_id,
                         client_secret = client_secret,
                         refresh_token = refresh_token)


})

names(reports_list) <- reports

return(reports_list)
}

