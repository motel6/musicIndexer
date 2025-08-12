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

    [[ "$mime_type" != audio/* ]] &&  log "warn" "${label}" "not an audio file, skip: $file_path" && exit 0

    set -e

    [[ -f "$path_to_output_file" ]] && rm "$path_to_output_file"

    "$path_to_extractor" "$file_path" "$path_to_output_file"

    # Read JSON content (escape single quotes for SQL)
    declare -r json_string=$(sed "s/'/''/g" "$path_to_output_file")

    # Prepare SQL query: update if acoustic_feature is NULL and file_path matches
    # Assuming the table 'music' has a column named 'file_path' to match the file, adjust if different
    declare -r sql_query_update="UPDATE carmen.music SET acoustic_feature = '$json_string' WHERE file_path = '${file_path//\'/\'\'}' AND acoustic_feature IS NULL;"

    # Run SQL query
    MYSQL_PWD="$password" mysql -u root -e "$sql_query_update"

    log "info" "${label}" "Update complete for: $file_path"
}

main "$@"