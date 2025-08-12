function forEach(){
    local -n array=$1
    local callback=$2   

    local arrayReturn=()

    for i in "${!array[@]}"; do
        "${callback}" "${array[${i}]}" "${i}" array
    done
}