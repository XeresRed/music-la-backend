#! /bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Varibles
TEMP_DIR="tempDir"
DOCKER_IMAGE="musicLa"
CONTAINER_NAME="cars-management-container"
PORT=3000
SERVER="server.js"
APP_VERSION="1.0.0"

DB_IMAGE="postgres"
DB_ADMIN_IMAGE="dpage/pgadmin4"



# Creando archivo de logs
mkdir -p logs
mkdir -p logs/docker
LOG_NAME_FILE=$( date -u +"%Y-%m-%dT%H:%M:%SZ" )-logs.txt
LOG_PATH=logs/$LOG_NAME_FILE
touch $LOG_PATH

# Definiendo metodos utilitarios
write_log(){
    local timestamp=$( date -u +"%Y-%m-%dT%H:%M:%SZ" )
    echo "$timestamp - ${message}" >> $LOG_PATH
}

print_message() {
    local color=$1
    local message=$2
    write_log
    local timestamp=$( date -u +"%Y-%m-%dT%H:%M:%SZ" )
    echo -e "${timestamp} - ${color}${message}${NC}"
}

check_installed_tools(){
    if command -v $1 &>/dev/null; then
        print_message $GREEN "$1 está instalado."
    else
        print_message $RED "$1 no está instalado. Por favor, instale $1 e intente nuevamente."
        exit 1
    fi
}

# Chequear herramientas para el script

print_message $YELLOW "Revisando herramientas"
check_installed_tools jq
check_installed_tools docker
check_installed_tools git
check_installed_tools node

# A. Leer version de la aplicacion
if [ -f "$TEMP_DIR/package.json" ]; then
    APP_VERSION=$(jq -r '.version' package.json)
    REPO_NAME=$(jq -r '.name' package.json)
    print_message $YELLOW "Versión de la aplicación: $APP_VERSION"
fi

# B. Obtener nombre del repo
print_message $YELLOW "URL repositorio: $REPO_NAME"
CURRENT_BRANCH=$(git branch --show-current)
print_message $YELLOW "Rama actual: $CURRENT_BRANCH"

# Construir strapi
npm run build

# C. Construir la imagen
DOCKER_IMAGE="$REPO_NAME:$APP_VERSION-latest"
print_message $GREEN "Nombre de la imagen: $DOCKER_IMAGE"

# Agregar servidor
cat <<EOF > $SERVER
const strapi = require('@strapi/strapi');
strapi.createStrapi(/* {...} */).start();
EOF

#  C1. eliminar imagenes
print_message $YELLOW "Eliminando imagenes antiguos..."

# Check if the images exist first
docker compose down -v

# Punto 3

# Construir la imagen
print_message $YELLOW "Construyendo imagen Docker..."
docker compose up -d  2> logs/docker/docker-build.log # Escribo la ejecucion del build en el log
CHECK_BUILD=$? # Retorna la respuesta del ultimo comando ejecutado, en este caso docker build ....

# Si hubo un error en el build, se escribe en el log y termina la ejecucion
if [ "$CHECK_BUILD" == "1" ]; then
    print_message $RED "[ERROR] Por favor revise el log del docker-build"
    exit 1
fi
