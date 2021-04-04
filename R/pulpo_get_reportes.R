#' Download reports to from zoho creator
#'
#'@param zoho_password A string. Password of araupontones in zoho creator
#'@param zoho_token A string. Token of Zoho creator API of araupontone
#' @return A list with the reports of: \code{invoices}, \code{gastos}, \code{receptores},
#' \code{expenses}

pulpo_get_reportes = function(zoho_password, zoho_token){
  zohor_login(zohor_server = "https://creator.zoho.com/api/json/pulpo/view/",
              zohor_user = "araupontones@gmail.com",
              zohor_ownername = "araupontones",
              zohor_scope = "creatorapi",
              zohor_token = "e61c6bb1c9792351a488d931374dd6c5",
              zohor_password = "Seguridad1@",
  )

  invoices = zohor_get_report(zohor_report ="All_Invoices")
  gastos = zohor_get_report("Gastos_Report")
  receptores = zohor_get_report("Receptores_Report")
  expenses = zohor_get_report("All_Expenses")
  projects = zohor_get_report("All_Projects")

  reportes = list(invoices = invoices,
                  gastos = gastos,
                  receptores = receptores,
                  expenses =expenses,
                  projects= projects)
}


