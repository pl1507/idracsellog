#!/bin/bash
function finalerror(){
    errdata=`cat errorcode.txt`
    if [[ -e errorcode.txt && ${errdata} == 1 ]] ;then
       exit 2
    fi
}
