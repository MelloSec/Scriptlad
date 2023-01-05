#!/bin/bash
if [ $# -eq 0 ];
then
  echo "Scanning '$cidr' subnet from exported variable cidr=x.x.x.x/xx"
  nmap -n -sn $cidr -oG - | awk '/Up$/{print $2}' | sort -V > nmapcidr.txt
  echo "Results saved as nmapcidr.txt"
elif [ $# -eq 1 ];
then
  echo "Argument passed, scanning '$1'"
  nmap -n -sn $1 -oG - | awk '/Up$/{print $2}' | sort -V > nmapargs.txt
  echo "Results saved as nmapargs.txt"
fi