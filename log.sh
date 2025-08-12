function log() {
    local level=$1
    local label=$2
    local message=$3

    local -r ERROR="ERROR" &>/dev/null
    local -r WARN="WARN" &>/dev/null
    local -r INFO="INFO" &>/dev/null
    local -r DEBUG="DEBUG" &>/dev/null
    local -r SILLY="SILLY" &>/dev/null

    local -r RED="\e[0;31m" &>/dev/null
    local -r YELLOW="\e[0;33m" &>/dev/null
    local -r GREEN="\e[0;32m" &>/dev/null
    local -r BLUE="\e[0;34m" &>/dev/null
    local -r PURPLE="\e[0;35m" &>/dev/null
    local -r RESET="\e[0m" &>/dev/null

    function log::toEcho() {
        local toEcho

        function log::toEcho::getControlSequenceCommandForColor() {
            local controlSequenceCommand

            case "${level^^}" in
            $ERROR)
                controlSequenceCommand=$RED
                ;;
            $WARN)
                controlSequenceCommand=$YELLOW
                ;;
            $INFO)
                controlSequenceCommand=$GREEN
                ;;
            $DEBUG)
                controlSequenceCommand=$BLUE
                ;;
            SILLY)
                controlSequenceCommand=$PURPLE
                ;;
            *)
                log $ERROR $FUNCNAME "wrong level specified: ${level}"
                exit 1
                ;;
            esac

            echo $controlSequenceCommand
        }

        function log::toEcho::getTimeString() {
            echo $(date --utc "+%Y-%m-%d %H:%M:%S.%3N +00:00")
        }

        toEcho="$(log::toEcho::getControlSequenceCommandForColor)[$(log::toEcho::getTimeString)] [${level}] [${label}] ${message}${RESET}"

        echo $toEcho
    }

    echo -e "$(log::toEcho)"
}
