#!/bin/bash

# Variables seguras
SERVICE_NAME="Transformation_Service"
TRANSFORM_SERVICE_HOME="/opt/alfresco/alfresco-transform-service"
PID_PATH_NAME_SERVICE="$TRANSFORM_SERVICE_HOME/Transformation_Service-pid"

# Variables de configuración del servicio
FILE_STORE_PATH="/opt/alfresco/alfresco-transform-service/stores/servicesStore"
SCHEDULER_CONTRACT_PATH="/opt/alfresco/alfresco-transform-service/stores/scheduler.json"

DIR_LOG=$TRANSFORM_SERVICE_HOME/logs
TEMPORARY=$DIR_LOG/tmp/
SERVICE_LOGS=$DIR_LOG/serviceLogs.txt
ERRORS_SERVICE_LOGS=$DIR_LOG/errorsServiceLogs.txt

JAR_FILE=alfresco-shared-file-store-controller-3.0.0.jar
# Función para iniciar el servicio
function start_service() {
  # Verifica si el PID del servicio existe
  if [ ! -f "$PID_PATH_NAME_SERVICE" ]; then
    # Inicia el servicio
    nohup java -XX:MinRAMPercentage=5 -XX:MaxRAMPercentage=10 -DfileStorePath="$FILE_STORE_PATH" -Dscheduler.contract.path="$SCHEDULER_CONTRACT_PATH" -jar $JAR_FILE $TEMPORARY 2>> $ERRORS_SERVICE_LOGS >> $SERVICE_LOGS & echo $! > "$PID_PATH_NAME_SERVICE"

    # Imprime un mensaje de confirmación
    echo "$SERVICE_NAME iniciado"
  else
    echo "$SERVICE_NAME ya está corriendo"
  fi
}

# Función para detener el servicio
function stop_service() {
  # Verifica si el PID del servicio existe
  if [ -f "$PID_PATH_NAME_SERVICE" ]; then
    # Obtiene el PID del servicio
    PID=$(cat "$PID_PATH_NAME_SERVICE")

    # Detiene el servicio
    kill "$PID"

    # Imprime un mensaje de confirmación
    echo "$SERVICE_NAME detenido"

    # Elimina el PID del archivo
    rm "$PID_PATH_NAME_SERVICE"
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
