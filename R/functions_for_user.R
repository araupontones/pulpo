#' Check that directory exists

create_dir_if_doesnt_exist <- function(dir_libros,
                                       year){

  dir_libros_year = file.path(dir_libros, year)

  #create directory of dir libros
  if(!dir.exists(dir_libros_year)){

    dir.create(dir_libros_year)
    message(glue("creating {dir_libros_year}" ))
  }

  return(dir_libros_year)

}


#'Check if directory for user exists
create_dir_user <- function(dir_libros_year, user){

 #define directory of user and excel file de libros
  dir_user = file.path(dir_libros_year, user)
  #excel_libros = file.path(dir_user,glue::glue("libro_gastos_{user}_{year}.xlsx"))


  #create directory of dir libros
  if(!dir.exists(dir_user)){

    dir.create(dir_user)

    message(glue::"creating {dir_user}")
  }

  return(dir_user)

}



#' Return user as in Zoho creator
get_user = function(user){

  #create libro by user

  if(user == "Andres") {

    usuario <- "Andrés Arau"

  } else if(user == "Martina"){

    usuario <- "Martina Garcia Aisa"
  } else if(user == "Pulpo") {

    usuario <- "Pulpo Data Sociedad Limitada"

  }

  return(usuario)


}









