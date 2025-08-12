function reduce() {
    local -n arraySrc=$1
    local callback=$2
    local -n dst=$3

    local temp="${arraySrc[0]}"

    for ((i = 1; i < "${#arraySrc[@]}"; i++)); do
        temp="$(${callback} ${arraySrc[${i}]} ${temp} ${i} arraySrc)"
    done

    dst=$temp
}
