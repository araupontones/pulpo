#'Export libro de ingresos
#'
#'


create_libro_ingresos <- function(db_ingresos,
                                  dir_libros,
                                  users = c("Andres", "Martina", "Pulpo"),
                                  year = 2021,
                                  ...) {

  #create directory of books
  dir_libros_year = create_dir_if_doesnt_exist(dir_libros, year)


  #create libro for user---------------------------------------------
  for(user in users){

    dir_user = create_dir_user(dir_libros_year, user)
    excel = file.path(dir_user,glue::glue("libro_ingresos_{user}_{year}.xlsx"))


    usuario <- get_user(user)

    if(user == "Pulpo") {

      data_for_template = db_ingresos %>%
        filter(Mode == "Pulpo")

    } else {

      data_for_template = db_ingresos %>%
        filter(Mode != "Pulpo",
               User == usuario)

    }

    data_for_template = data_for_template %>%
      select(-User, -Mode)

    template_libro_ingresos(data_for_template,
                            excel,
                            year, ...)

    message(excel)


  }




}





