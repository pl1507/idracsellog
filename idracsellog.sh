#!/bin/bash
#Author: Timmy Chang
function usage(){
    echo "
Usage: ./idracsellog.sh target_IP
Example: ./idracsellog.sh 10.99.239.1

" 1>&2;
    exit 1;
}
[ "$1" == "" ] && usage

chmod -R 755 *
#source ./function/ipmiselelist.sh
source ./function/racadmgetsel.sh
source ./function/racadmlclog.sh
source ./function/finalerror.sh

iDRACIP=$1

#ipmiselelist
racadmgetsel
racadmlclog
finalerror
