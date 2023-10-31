#!/bin/bash

# Variables seguras
SERVICE_NAME="Transformation_Router"
TRANSFORM_SERVICE_HOME="/opt/alfresco/alfresco-transform-service"
PID_PATH_NAME_ROUTER="$TRANSFORM_SERVICE_HOME/Transformation_Router-pid"

# Variables de configuración del servicio
SERVER_TOMCAT_THREADS_MAX=12
SERVER_TOMCAT_THREADS_MIN=4
CORE_AIO_URL="http://localhost:8090"
CORE_AIO_QUEUE="org.alfresco.transform.engine.aio.acs"
ACTIVEMQ_URL='failover:(tcp://localhost:61616)?timeout=3000'
FILE_STORE_URL="http://localhost:8099/alfresco/api/-default-/private/sfs/versions/1/file"


DIR_LOG=$TRANSFORM_SERVICE_HOME/logs
TEMPORARY=$DIR_LOG/tmp/
ROUTER_LOGS=$DIR_LOG/routerLogs.txt
ERRORS_ROUTER_LOGS=$DIR_LOG/errorsRouterLogs.txt

JAR_FILE=alfresco-transform-router-3.0.0.jar
# Función para iniciar el servicio
function start_service() {
  # Verifica si el PID del servicio existe
  if [ ! -f "$PID_PATH_NAME_ROUTER" ]; then
    # Inicia el servicio
    nohup java $JAVA_OPTS -Dserver.tomcat.threads.max="$SERVER_TOMCAT_THREADS_MAX" -Dserver.tomcat.threads.min="$SERVER_TOMCAT_THREADS_MIN" -XX:MinRAMPercentage=5 -XX:MaxRAMPercentage=10 -DCORE_AIO_URL="$CORE_AIO_URL" -DCORE_AIO_QUEUE="$CORE_AIO_QUEUE" -DACTIVEMQ_URL="$ACTIVEMQ_URL" -DFILE_STORE_URL="$FILE_STORE_URL" -jar $JAR_FILE $TEMPORARY 2>> $ERRORS_ROUTER_LOGS >> $ROUTER_LOGS & echo $! > "$PID_PATH_NAME_ROUTER"

    # Imprime un mensaje de confirmación
    echo "$SERVICE_NAME iniciado"
  else
    echo "$SERVICE_NAME ya está corriendo"
  fi
}

# Función para detener el servicio
function stop_service() {
  # Verifica si el PID del servicio existe
  if [ -f "$PID_PATH_NAME_ROUTER" ]; then
    # Obtiene el PID del servicio
    PID=$(cat "$PID_PATH_NAME_ROUTER")

    # Detiene el servicio
    kill "$PID"

    # Imprime un mensaje de confirmación
    echo "$SERVICE_NAME detenido"

    # Elimina el PID del archivo
    rm "$PID_PATH_NAME_ROUTER"
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
