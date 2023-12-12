function hip {
    HIS=`history | peco | awk '{ $1=""; print $0}'`
    echo ${HIS}
    eval "${HIS}"
}