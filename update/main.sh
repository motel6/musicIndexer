function main() {
    local label=$([[ "${BASH_SOURCE}" =~ (/.*/.*$)|(./[^/]*$) ]] && echo "${BASH_REMATCH#/}/${FUNCNAME}")

    cd "${BASH_SOURCE%/*}"

    source "../log.sh"
    
    local -r column=$1

    shift

    case "${column}" in
    "acoustic_feature")
        bash -c 'source ./acoustic_feature/main.sh && main "$@"' _ "$@"
        ;;
    *)
        log "error" "${label}" "invalid column: ${column}"
        ;;
    esac

    shift
}
