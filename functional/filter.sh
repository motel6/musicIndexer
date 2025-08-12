function filter(){
    local -n arraySrc=$1
    local callback=$2
    local -n arrayDst=$3   

    local arrayTemp=()

    for i in "${!arraySrc[@]}"; do
        "${callback}" "${arraySrc[${i}]}" "${i}" arraySrc && arrayTemp+=("${arraySrc[${i}]}")
    done

    arrayDst=()

    for i in "${!arrayTemp[@]}"; do
         arrayDst+=("${arrayTemp[${i}]}")
    done
}