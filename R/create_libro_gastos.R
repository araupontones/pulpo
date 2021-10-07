#'create libro de gastos
#'
#'@param db_gastos A tibble with the gastos. This data base is returned by \code{pulpo_clean_gastos()}
#'@param dir_libros A directory path to export the books
#'@param users A string. Name for which the book will be created. Options: c("Andres", "Martina", "Pulpo")
#'@result An excel file with the books for the user stored in \code{dir_libros/year/User}


create_libro_gastos <- function(db_gastos,
                                dir_libros,
                                users = c("Andres", "Martina", "Pulpo"),
                                year = 2021,
                                ...){

  #create directory of books

  dir_libros_year = create_dir_if_doesnt_exist(dir_libros, year)


  #create libro for user---------------------------------------------
  for(user in users){

    dir_user = create_dir_user(dir_libros_year, user)
    excel = file.path(dir_user,glue::glue("libro_gastos_{user}_{year}.xlsx"))


    usuario <- get_user(user)


    db_gastos %>%
      filter(Users == usuario) %>%
      select(-Users) %>%
      rio::export(excel, overwrite = T)

    message(excel)


  }




}
