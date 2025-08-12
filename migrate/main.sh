function main() {
    local label=$([[ "${BASH_SOURCE}" =~ (/.*/.*$)|(./[^/]*$) ]] && echo "${BASH_REMATCH#/}/${FUNCNAME}")

    cd "${BASH_SOURCE%/*}"

    source "../log.sh"

    log "debug" "${label}" "starting sub-program: migrate"

    log "error" "${label}" "to be implemented"

    log "debug" "${label}" "finished sub-program: migrate"
}
