#!/bin/sh

domain="$1"
outfile="$2"

dig +short NS $domain > nameservers.txt

while read nameservers; do
  echo "For NS: $nameservers.."
  timeout 10 dig axfr @$nameservers $domain | grep ".$domain" | awk '{print $1}' > "$nameservers"results
  tail -n +2 "$nameservers"results | tee "$nameservers"results
  echo "==============================================="
  echo
done <nameservers.txt

sort -u *.results > tmp.txt

sedstr=s/$domain.*/$domain/g; 
cat tmp.txt | sed 's/[[:space:]]//g' | sed $sedstr | sort -u > "$outfile"

echo "$domain" >> "$outfile"

rm *.results
rm nameservers.txt
rm tmp.txt
