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

sort -u *.results > "$outfile"

rm *.results
rm nameservers.txt

echo "$domain" >> "$outfile"
