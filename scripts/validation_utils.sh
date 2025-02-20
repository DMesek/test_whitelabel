REQUIRED_CONFIG_KEYS=("BUNDLE_ID" "APP_NAME" "ANDROID_APP_ID")
REQUIRED_ENV_KEYS=("PRIMARY_COLOR")

validate_client_folder_provided() {
    if [ -z "$CLIENT_FOLDER" ]; then
        echo "Usage: $0 --client_folder <client_folder>"
        echo "Example: $0 'client1'"
        exit 1
    fi
}

validete_config_json() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: config.json file does not exist in $CLIENT_FOLDER"
        exit 1
    fi


    if ! jq -e "$(printf 'has("%s") and ' "${REQUIRED_CONFIG_KEYS[@]}" | sed 's/ and $//')" "$CONFIG_FILE" > /dev/null; then
        echo "Error: Config file must contain ${REQUIRED_CONFIG_KEYS[*]} keys"
        exit 1
    fi
}

validete_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        echo "Error: .env file does not exist in $CLIENT_FOLDER"
        exit 1
    fi

    for key in "${REQUIRED_ENV_KEYS[@]}"; do
        if ! grep -q "^$key=" "$ENV_FILE"; then
            echo "Error: Required key '$key' not found in .env file"
            exit 1
        fi
    done
}

validate_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed"
        exit 1
    fi
}
