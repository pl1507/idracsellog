#!/bin/bash
function racadmlclog(){
  racadm -r $iDRACIP -u root -p calvin --nocertwarn lclog view -s warning,critical > racadmlclogwc.txt
  declare -i Totallclogcount=`grep -c SeqNumber racadmlclogwc.txt`
  declare -i Warninglclogcount=`grep -c "Severity        = Warning" racadmlclogwc.txt`
  declare -i Criticallclogcount=`grep -c "Severity        = Critical" racadmlclogwc.txt`

  #Data summary
  levellist="Warning Critical"
  for level in $levellist; do
     if [[ $level == "Warning" ]] ;then
       declare -i currentlclogcount=$Warninglclogcount
     else
       declare -i currentlclogcount=$Criticallclogcount
     fi

     grep -A 2 -B 3 "Severity        = ${level}" racadmlclogwc.txt | grep Message > racadmlclog${level}_tmp.txt
     sed  "s/\r//" racadmlclog${level}_tmp.txt > racadmlclog${level}_2tmp.txt
     for (( i=1; i<=$currentlclogcount; i=i+2 ))
     do
       ID=`cat racadmlclog${level}_2tmp.txt | head -$i | tail -n 1 | awk '{print $4}'`
       echo -e "$ID = \c" >> racadmlclog${level}_3tmp.txt
       Message=`cat racadmlclog${level}_2tmp.txt | head -$(($i+1)) | tail -n 1 | cut -d '=' -f 2`
       echo "$Message" >> racadmlclog${level}_3tmp.txt
     done
     sort racadmlclog${level}_3tmp.txt | uniq > racadmlclog${level}.txt
     rm -rf *tmp.txt
  done

  #Warning lclog allow list check
  Warningcheckresult=`awk 'NR==FNR{A[$1]; next}!($1 in A)' function/Warningwhitelist.txt racadmlclogWarning.txt`
  if [[ -n $Warningcheckresult ]] ;then
     echo "Warning level LC log:"
     awk 'NR==FNR{A[$1]; next}!($1 in A)' function/Warningwhitelist.txt racadmlclogWarning.txt | tee -a filter_lclogWarning.txt
     echo 1 > errorcode.txt
  else
     echo "No unexpected Warning logs."
  fi

  #Critical lclog allow list check
  Criticalcheckresult=`awk 'NR==FNR{A[$1]; next}!($1 in A)' function/Criticalwhitelist.txt racadmlclogCritical.txt`
  if [[ -n $Criticalcheckresult ]] ;then
     echo "Critical level LC log:"
     awk 'NR==FNR{A[$1]; next}!($1 in A)' function/Criticalwhitelist.txt racadmlclogCritical.txt | tee -a filter_lclogCritical.txt
     echo 1 > errorcode.txt
  else
     echo "No unexpected Critical logs."
  fi
}
