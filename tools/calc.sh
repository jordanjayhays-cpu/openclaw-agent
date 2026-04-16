#!/bin/bash
# Shared calculation library - use awk instead of bc
# Source this file: source $(dirname $0)/calc.sh

calc() {
    # Simple calculator using awk
    # Usage: calc "1 + 2" or calc "3 * 4.5"
    echo "$1" | awk "{printf \"%.2f\", $1}"
}

calc_int() {
    # Integer calculator
    echo "$1" | awk "{printf \"%.0f\", $1}"
}

calc_percent() {
    # Calculate percentage: calc_percent value rate
    # Example: calc_percent 50000 0.10 = 5000
    echo "$1 * $2" | awk "{printf \"%.2f\", $1 * $2}"
}
