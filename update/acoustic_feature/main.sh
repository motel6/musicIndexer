function main() {
    local label=$([[ "${BASH_SOURCE}" =~ (/.*/.*$)|(./[^/]*$) ]] && echo "${BASH_REMATCH#/}/${FUNCNAME}")

    cd "${BASH_SOURCE%/*}"

    source "../../log.sh"

    local -r root_directory=$1
    local -r password=$2

    shift 2

    [[ "${root_directory}" == "" ]] && log "error" "${label}" "root directory specified can not be empty" && exit 1
    [[ "${password}" == "" ]] && log "error" "${label}" "password specified can not be empty" && exit 1

    log "debug" "${label}" "starting sub-program: acoustic_feature"
    
    find "$root_directory" -type f -exec "./update.sh" {} "$password" \;

    log "debug" "${label}" "finished sub-program: acoustic_feature"
}
