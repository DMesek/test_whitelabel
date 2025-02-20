#!/bin/bash
source ./upload_utils.sh
source ./validation_utils.sh

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --client_folder) CLIENT_FOLDER="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

validate_client_folder_provided

CLIENT_NAME=$(basename "$CLIENT_FOLDER")
ENV_FILE="$CLIENT_FOLDER/.env"
CONFIG_FILE="$CLIENT_FOLDER/config.json"

validete_env_file
validete_config_json

echo "Uploading $CLIENT_NAME variables to Codemagic..."

upload_env_file "$ENV_FILE" "$CLIENT_NAME"
upload_config_json "$CONFIG_FILE" "$CLIENT_NAME"

echo "Upload complete!"


