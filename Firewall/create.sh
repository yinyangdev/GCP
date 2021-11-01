#!/bin/bash

COUNTRY_CODE="JP"
FW_NAME="vpc-https-"
ALLOW="tcp:443"
DESC="HTTPS 日本IPのみ"
NETWORK="vpc-nw"
TAGS="https-jp"

sed -n 's/^'$COUNTRY_CODE'\t//p' ip.txt > ccip.txt


numLine=1
numfw=1
IPLIST=""

for line in `cat ccip.txt`
do
 IPLIST=$IPLIST$line","
 if [ $numLine -eq 256 ]; then
  echo -e "$IPLIST ------ \n"
  IPLIST=`echo $IPLIST | sed -e 's/,$//'`
  gcloud compute firewall-rules create $FW_NAME$numfw --allow $ALLOW --network $NETWORK --target-tags=$TAGS --description "$DESC" --source-ranges "$IPLIST" &
  IPLIST=""
  numLine=0
  numfw=$((numfw + 1))
 fi
 numLine=$((numLine + 1))
done
gcloud compute firewall-rules create $FW_NAME$numfw --allow $ALLOW --network $NETWORK --target-tags=$TAGS --description "$DESC" --source-ranges "$IPLIST" &
rm ccip.txt
