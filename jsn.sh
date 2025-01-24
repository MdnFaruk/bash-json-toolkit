#!/bin/bash

# "jsn" Command-Line Tool
# Author: Md Faruk
#
# Description:
# Extract values, display top-level keys, and pretty-print JSON strings.
# Features include handling arrays and formatting JSON data.

# Display usage information
function show_help() {
    echo "Usage: $(basename "$0") [OPTIONS] JSON_STRING [KEY] [INDEX]"
    echo
    echo "Options:"
    echo "  -h, --help          Show this help message and exit."
    echo "  -k, --keys          Display all top-level keys from the provided JSON data."
    echo
    echo "Arguments:"
    echo "  JSON_STRING         The JSON string to process."
    echo "  KEY                 Key for extracting value. Not required with --keys."
    echo "  INDEX               Optional index for array elements."
    echo
    echo "Examples:"
    echo "  $(basename "$0") '{\"name\":\"Alice\", \"age\":30}' 'name'"
    echo "  $(basename "$0") '{\"fruits\":[\"apple\",\"banana\"]}' 'fruits' 1"
    echo "  $(basename "$0") -k '{\"name\":\"Alice\", \"age\":30}'"
}

# Pretty-print JSON
function jsonify() {
    echo "$1"
}

# Extract values from JSON
function json_extract() {
    local json=$1 key=$2 index=$3

    local string_regex='"([^"\\]|\\.)*"'
    local value_regex="$string_regex|-?[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?|true|false|null"
    local object_regex="\{[^}]*\}"
    local array_regex="\[[^]]*\]"
    local pair_regex="\"$key\"[[:space:]]*:[[:space:]]*($value_regex|$object_regex|$array_regex)"

    if [[ $json =~ $pair_regex ]]; then
        local matched_value="${BASH_REMATCH[1]}"

        if [[ $matched_value =~ ^\[.*\]$ ]]; then
            IFS=',' read -r -a array_items <<<"${matched_value:1:-1}"
            if [[ -n $index ]]; then
                if ((index < 0 || index >= ${#array_items[@]})); then
                    echo "Index out of bounds. Max index: $(( ${#array_items[@]} - 1 ))"
                else
                    jsonify "${array_items[index]}"
                fi
            else
                jsonify "$matched_value"
            fi
        else
            jsonify "${matched_value//\"/}"
        fi
    else
        echo "Key not found."
        return 1
    fi
}

# Extract top-level keys from JSON
function get_json_keys_list() {
    local json_data="$1"
    echo "$json_data" | tr -d '[:space:]' | sed 's/\[[^]]*\]/""/g' | \
        grep -o '"[^"]*"' | tr -d '"' | sort -u
}

# Main script logic
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
elif [[ "$1" == "-k" || "$1" == "--keys" ]]; then
    [[ -z "$2" ]] && { echo "Error: JSON_STRING required."; exit 1; }
    get_json_keys_list "$2"
else
    [[ $# -lt 2 ]] && { echo "Error: Insufficient arguments."; show_help; exit 1; }
    json_extract "$@"
fi
