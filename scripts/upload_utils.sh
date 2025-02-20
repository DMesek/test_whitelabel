WORKFLOW_ID="67b05c01ee54e33cf7533f75"
APP_ID="67b05c01ee54e33cf7533f76"
AUTH_TOKEN="vhhMKHNg-jc0swNP-4Ab9Y9-ZKfHaC4gNu9ZMPZllP4"

API_URL="https://api.codemagic.io/apps/$APP_ID/variables"

upload_variable() {
    local key="$1"
    local value="$2" 
    local group="$3"
    local secure="$4"

    curl -XPOST \
        -H "x-auth-token: $AUTH_TOKEN" \
        -H "Content-type: application/json" \
        -d "{
            \"key\": \"$key\",
            \"value\": \"$value\", 
            \"group\": \"$group\",
            \"workflowId\": \"$WORKFLOW_ID\",
            \"secure\": $secure
        }" \
        "$API_URL"
    echo ""
}

upload_env_file() {
    local file_path="$1"
    local group="$2"

    file_content=$(cat "$file_path" | base64)
    upload_variable "ENV" "$file_content" "$group" false
}

upload_config_json() {
    local config_path="$1"
    local group="$2"

    jq -r 'to_entries | .[] | "\(.key)=\(.value)"' "$config_path" | while IFS='=' read -r key value; do
        echo "Uploading $key=$value to group $group"
        upload_variable "$key" "$value" "$group" false
        # Add a small delay to prevent rate limiting
        sleep 1
    done
}



