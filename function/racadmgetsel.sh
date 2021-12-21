#!/bin/bash
function racadmgetsel(){
  racadm -r $iDRACIP -u root -p calvin --nocertwarn getsel -o > racadmgetsel.txt
  Totalselcount=`grep -i -c system racadmgetsel.txt`
  sleep 2
  echo "Total is ${Totalselcount} events in SEL."

  declare -i notokeventcount=`grep system racadmgetsel.txt | grep -i -c -E "Critical|error"`
  if [[ $notokeventcount != 0 ]] ;then
     echo -e "There is ${notokeventcount} non-ok events in SEL:\n"
     grep system racadmgetsel.txt | grep -i -E "Critical|error"
     echo 1 > errorcode.txt
  else
     echo "Racadm SEL no critical or error event!"
  fi
}
