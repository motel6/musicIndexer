#!/bin/bash

function main(){
    local -r label=$([[ "${BASH_SOURCE}" =~ (/.*/.*$)|(./[^/]*$) ]] && echo "${BASH_REMATCH#/}/${FUNCNAME}")

    cd "${BASH_SOURCE%/*}"

    source "../../log.sh"

    declare -r file_path=$(realpath "$1")
    declare -r password="$2"

    declare -r sql_query_is_exist="SELECT COUNT(*) FROM carmen.music WHERE file_path='${file_path//\'/\'\'}' and acoustic_feature IS NULL;"

    declare -r count=$(MYSQL_PWD="$password" mysql -u root -N -s -e "$sql_query_is_exist")

    [[ "$count" -eq 0 ]] && log "warn" "${label}" "not exist or already updated, skip: $file_path" && exit 0

    declare -r mime_type=$(file --mime-type -b "$file_path")

    [[ "$mime_type" != audio/* ]] &&  log "warn" "${label}" "not an audio file, skip: $file_path" && exit 0

    set -e

    [[ -f "$path_to_output_file" ]] && rm "$path_to_output_file"

    log "info" "${label}" "Analyzing for: $file_path"

    "$path_to_extractor" "$file_path" "$path_to_output_file"

    # Create a temporary SQL file
    declare -r tmp_sql=$(mktemp)
    
    # Use jq to correctly escape the JSON, then sed to handle SQL-specific escaping.
    {
     printf "UPDATE carmen.music SET acoustic_feature = "
     jq @json "$path_to_output_file"
     printf " WHERE file_path = '%s' AND acoustic_feature IS NULL;\n" "${file_path//\'/\'\'}"
    } > "$tmp_sql"

    # Run the SQL query from the temporary file.
    MYSQL_PWD="$password" mysql -u root < "$tmp_sql"

    rm -f "$tmp_sql"

    log "info" "${label}" "Update complete for: $file_path"
}

main "$@"