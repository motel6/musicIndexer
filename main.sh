function main() {
    local label=$([[ "${BASH_SOURCE}" =~ (/.*/.*$)|(./[^/]*$) ]] && echo "${BASH_REMATCH#/}/${FUNCNAME}")

    cd "${BASH_SOURCE%/*}"

    source "./log.sh"
    
    export path_to_extractor="/home/opensilence/Downloads/essentia-extractors-v2.1_beta2/streaming_extractor_music"
    export path_to_output_file="./output.json"

    local -r verb=$1

    shift

    case "${verb}" in
    "migrate")
        bash -c "source ./migrate/main.sh && main $(echo $@)"
        ;;
    "update")
        bash -c 'source ./update/main.sh && main "$@"' _ "$@"
        ;;
    *)
        log "error" "${label}" "invalid verb: ${verb}"
        ;;
    esac

    shift
}
