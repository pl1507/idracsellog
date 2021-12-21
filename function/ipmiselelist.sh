#!/bin/bash
function ipmiselelist(){
  racadm -r $iDRACIP -u root -p calvin set iDRAC.IPMILan.Enable 1
  sleep 1
  ipmitool -I lanplus -H $iDRACIP -U root -P calvin sel elist > ipmiselelist.txt

  logs=$(cat ipmiselelist.txt | awk -F\| '{print $4"|"$5"|"$6}' | sed -r 's,^ | $,,g' | sort -V | sed -r 's,$,;,g')
  while IFS= read -r e
  do
     printf "Event: %-100s%5s%d\n" "$e" "Number: " $(echo $logs | tr -s ';' '\n' | sed -r 's,^ | $,,g' | grep -c "$e") ;
  done <<< "$(echo $logs | sed -r 's,;,\n,g' | sed -r 's,^ | $,,g' | uniq)"
}
