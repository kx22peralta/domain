#!/bin/bash

# Variables
SERVICE_NAME="Local_Transformation_Service"
TRANSFORM_SERVICE_HOME="/opt/alfresco/alfresco-transform-service"
PID_PATH_NAME_LOCAL="$TRANSFORM_SERVICE_HOME/Local_Transformation_Service-pid"

# Variables de configuración del servicio
PDFRENDERER_EXE="$TRANSFORM_SERVICE_HOME/alfresco-pdf-renderer/alfresco-pdf-renderer"
LIBREOFFICE_HOME="/opt/libreoffice7.2"
IMAGEMAGICK_ROOT="/opt/alfresco/ImageMagick-7.1.0-31"
IMAGEMAGICK_DYN="/usr/local/lib"
IMAGEMAGICK_EXE="/usr/local/bin/convert"
IMAGEMAGICK_CODERS="$IMAGEMAGICK_ROOT/coders"
IMAGEMAGICK_CONFIG="$IMAGEMAGICK_ROOT/config"
ACTIVEMQ_URL='failover:(tcp://localhost:61616)?timeout=3000'
FILE_STORE_URL=http://localhost:8099/alfresco/api/-default-/private/sfs/versions/1/file

DIR_LOG=$TRANSFORM_SERVICE_HOME/logs
TEMPORARY=$DIR_LOG/tmp/
LOCAL_LOGS=$DIR_LOG/localLogs.txt
ERRORS_LOCAL_LOGS=$DIR_LOG/errorsLocalLogs.txt

JAR_FILE=alfresco-transform-core-aio-4.0.0.jar
# Función para iniciar el servicio
function start_service() {
  # Verifica si el PID del servicio existe
  if [ ! -f "$PID_PATH_NAME_LOCAL" ]; then
    # Inicia el servicio
    nohup java $JAVA_OPTS -XX:MinRAMPercentage=10 -XX:MaxRAMPercentage=20 -DPDFRENDERER_EXE="$PDFRENDERER_EXE" -DLIBREOFFICE_HOME="$LIBREOFFICE_HOME" -DIMAGEMAGICK_ROOT="$IMAGEMAGICK_ROOT" -DIMAGEMAGICK_DYN="$IMAGEMAGICK_DYN" -DIMAGEMAGICK_EXE="$IMAGEMAGICK_EXE" -DIMAGEMAGICK_CODERS="$IMAGEMAGICK_CODERS" -DIMAGEMAGICK_CONFIG="$IMAGEMAGICK_CONFIG" -DACTIVEMQ_URL="$ACTIVEMQ_URL" -DFILE_STORE_URL="$FILE_STORE_URL" -jar $JAR_FILE $TEMPORARY 2>> $ERRORS_LOCAL_LOGS >> $LOCAL_LOGS & echo $! > "$PID_PATH_NAME_LOCAL"

    # Imprime un mensaje de confirmación
    echo "$SERVICE_NAME iniciado"
  else
    echo "$SERVICE_NAME ya está corriendo"
  fi
}

# Función para detener el servicio
function stop_service() {
  # Verifica si el PID del servicio existe
  if [ -f "$PID_PATH_NAME_LOCAL" ]; then
    # Obtiene el PID del servicio
    PID=$(cat "$PID_PATH_NAME_LOCAL")

    # Detiene el servicio
    kill "$PID"

    # Imprime un mensaje de confirmación
    echo "$SERVICE_NAME detenido"

    # Elimina el PID del archivo
    rm "$PID_PATH_NAME_LOCAL"
  else
    echo "$SERVICE_NAME no está corriendo"
  fi
}

# Función para reiniciar el servicio
function restart_service() {
  # Detiene el servicio
  stop_service

  # Inicia el servicio
  start_service
}

# Llama a la función adecuada según el argumento recibido
case "$1" in
start)
  start_service
;;
stop)
  stop_service
;;
restart)
  restart_service
;;
*)
  echo "Uso: $0 {start|stop|restart}"
;;
esac
