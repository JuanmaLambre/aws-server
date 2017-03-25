function parse_args() {
    while [[ $# -gt 0 ]]; do
        if [[ $1 =~ ^--.* ]]; then
            argname=$(echo ${1:2} | sed -e "s/-/_/g" | awk '{print toupper($0)}')
            export ARG_$argname=$(test $2 && echo $2 || echo 1)
        fi
        shift
    done
}
