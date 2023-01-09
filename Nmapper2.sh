#!/bin/bash

function usage {
    echo "Usage: $0 [OPTIONS] [TARGET]"
    echo "Options:"
    echo "  -t, --target-list      Create a target list from live hosts"
    echo "  -u, --up               Only show live hosts"
    echo "  -m, --mass             Use Masscan instead of NMAP"
    echo "  -A, --oA               Save NMAP/Masscan output in the 'oA' format"
    echo "  -G, --oG               Save NMAP/Masscan output in the 'oG' format"
    echo "  -X, --oX               Save NMAP/Masscan output in the 'oX' format"
    echo "  -P, --assume-up        Assume all hosts are up (skip host discovery)"
    echo "  -h, --help             Show this help message"
    exit
}

function get_target {
    read -rp "Enter target: " target
    echo "$target"
}

function nmap_scan {
    target=$1
    options=$2
    format="-oN"
    if [[ "$options" == *"--oA"* ]]; then
        format="-oA"
    elif [[ "$options" == *"--oG"* ]]; then
        format="-oG"
    elif [[ "$options" == *"--oX"* ]]; then
        format="-oX"
    fi
    if [[ "$options" == *"--target-list"* ]]; then
        nmap $target $format - | awk '/Up$/{print $2}' | sort -V > targets.txt
        echo "Live host list saved to targets.txt"
    elif [[ "$options" == *"--up"* ]]; then
        nmap $target -A -sV -T4 $format - | awk '/Up$/{print $2}' | sort -V > alive.txt
        echo "NMAP scan results saved to alive.txt"
    else
        nmap $target -A -sV -T4 $format - > nmap.txt
        echo "NMAP scan results saved to nmap.txt"
    fi
}

function masscan_scan {
    target=$1
    options=$2
    format="-oL"
    if [[ "$options" == *"--oA"* ]]; then
        format="-oA"
    elif [[ "$options" == *"--oG"* ]]; then
        format="-oG"
    elif [[ "$options" == *"--oX"* ]]; then
        format="-oX"
    fi
    if [[ "$options" == *"--target-list"* ]]; then
        masscan $target $format - | awk '/Up$/{print $2}' | sort -V > mass_targets.txt
        echo

        "Live host list saved to mass_targets.txt"
    elif [[ "$options" == *"--up"* ]]; then
        masscan $target $format - | awk '/Up$/{print $2}' | sort -V > massalive.txt
        echo "Masscan scan results saved to massalive.txt"
    else
        masscan $target $format - > mass.txt
        echo "Masscan scan results saved to mass.txt"
    fi
}

if [[ $# -eq 0 ]]; then
    target=$(get_target)
    options="--target-list"
    nmap_scan $target $options
elif [[ $# -gt 0 ]]; then
    target=$1
    shift
    options=$@
    if [[ "$options" == *"--mass"* ]]; then
        masscan_scan $target $options
    else
        nmap_scan $target $options
    fi
fi