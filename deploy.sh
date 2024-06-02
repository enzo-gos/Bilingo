#!/bin/bash

# Parse command line arguments or use default values
while [[ $# -gt 0 ]]; do
    case "$1" in
        --service)
            SERVICE="$2"
            shift 2
            ;;
        --service-path)
            SERVICE_PATH="$2"
            shift 2
            ;;
        --mode)
            MODE="$2"
            shift 2
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done

# Ensure all required parameters are provided
if [[ -z $SERVICE || -z $SERVICE_PATH || -z $MODE ]]; then
    echo "Usage: $0 --service <SERVICE> --service-path <SERVICE_PATH> --mode <MODE>"
    exit 1
fi

SERVICE_DIR="${SERVICE_PATH}/${SERVICE}"

if [[ $MODE == "init" ]]; then
  if [[ ! -d $SERVICE_DIR ]]; then
      mkdir -p "$SERVICE_DIR"
  fi
fi

if [[ $MODE == "deploy" ]]; then
  if [[ ! -d $SERVICE_DIR ]]; then
    echo 'Please intialize project before deploy'
    exit 1
  fi
  echo "Start build and deploy"

  cd $SERVICE_DIR
  docker compose -f docker-compose.prod.yml down "$SERVICE"
  docker compose -f docker-compose.prod.yml pull "$SERVICE"
  docker compose -f docker-compose.prod.yml up "$SERVICE" -d
  docker system prune -a -f

  echo "Deploy successfully"
fi

if [[ $MODE == "all" ]]; then
  if [[ ! -d $SERVICE_DIR ]]; then
    echo 'Please intialize project before deploy'
    exit 1
  fi
  echo "Start build and deploy"

  cd $SERVICE_DIR
  docker compose -f docker-compose.prod.yml down
  docker compose -f docker-compose.prod.yml pull
  docker compose -f docker-compose.prod.yml up -d
  docker system prune -a -f

  echo "Deploy successfully"
fi
