function map(){
    local -n arraySrc=$1
    local callback=$2   
    local -n arrayDst=$3  
    
    local arrayTemp=()

    for i in "${!arraySrc[@]}"; do
         arrayTemp+=("$("${callback}" "${arraySrc[${i}]}" "${i}" arraySrc)")
    done
    
    arrayDst=()
    
    for i in "${!arrayTemp[@]}"; do
         arrayDst+=("${arrayTemp[${i}]}")
    done
}