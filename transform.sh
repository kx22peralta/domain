#!/bin/bash


# Funcion para crear las carpetas logs y stores si no existen
create_folders_if_not_exist() {
  logs_folder="$(dirname "$(realpath "$0")")/logs"
  stores_folder="$(dirname "$(realpath "$0")")/stores"
  tmp_folder="$(dirname "$(realpath "$0")")/logs/tmp"

  if [ ! -d "$logs_folder" ]; then
    mkdir "$logs_folder"
    echo "Carpeta logs creada en $logs_folder."
  fi

  if [ ! -d "$stores_folder" ]; then
    mkdir "$stores_folder"
    echo "Carpeta stores creada en $stores_folder."
  fi

  if [ ! -d "$tmp_folder" ]; then
    mkdir "$tmp_folder"
    echo "Carpeta tmp creada en $stores_folder."
  fi

}

case $1 in
start)
  create_folders_if_not_exist
  ./serviceTransformation.sh start
  ./localTransformation.sh start
  ./routerTransformation.sh start
;;
stop)
  create_folders_if_not_exist
  ./serviceTransformation.sh stop
  ./localTransformation.sh stop
  ./routerTransformation.sh stop
;;
restart)
  create_folders_if_not_exist
  ./serviceTransformation.sh restart
  ./localTransformation.sh restart
  ./routerTransformation.sh restart
;;
*)
  echo "Uso: $(dirname "$(realpath "$0")") {start|stop|restart}"
  exit 1
 esac
