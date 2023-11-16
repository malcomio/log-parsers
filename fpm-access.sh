#!/usr/bin/env bash

# Parse an fpm-access log file into CSV for easier analysis.
# usage log-analysis-fpm-access.sh /path/to/logfile.txt
# Format based on https://docs.acquia.com/cloud-platform/monitor/logs/fpm-access/

# Get the directory that the script is in, no matter where it has been called from.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

LOG_FILE=$1

DATE=$(date "+%Y-%m-%d_%H-%M")

OUTPUT_FILE="${SCRIPT_DIR}/log-analysis-fpm-access-${DATE}.csv"

echo "IP address,Unused field,Date,Time,Method,Path,Status Code,Peak memory PHP,CPU percent,Duration,Request ID" >"${OUTPUT_FILE}"

# If there is no IP address, wrap the dash in quotes and add a comma
# Replace all commas with spaces
# Parse the IP address
# Put comma after unused field - TODO: what about user name?
# Parse the date and time
# Remove the timezone offset
# Wrap the HTTP method in quotes if it is GET
# Wrap the HTTP method in quotes if it is OPTIONS
# Wrap the HTTP method in quotes if it is POST - TODO: combine these three lines into one regex
# Parse the status code
# Convert all spaces between quotes into commas
# Remove memory_kb prefix
# Remove %cpu prefix
# Remove duration_ms prefix
# Remove request_id prefix
cat "${LOG_FILE}" | sed -e 's/^- /\"-\",/' \
  -e 's/,/ /g' \
  -e 's/\([0-9]\{1,3\}\.\)\([0-9]\{1,3\}\.\)\([0-9]\{1,3\}\.\)\([0-9]\{1,3\}\)/\"\1\2\3\4\",/' \
  -e 's/\( -\) /\1,/' \
  -e 's/\([0-9]\{2\}\)\/\(...\)\/\([0-9]\{4\}\):/\1 \2 \3,/' \
  -e "s/ $(date +%z) /,/" \
  -e 's/\"GET /\"GET\",\"/' \
  -e 's/\"OPTIONS /\"OPTIONS\",\"/' \
  -e 's/\"POST /\"POST\",\"/' \
  -e 's/\" \([0-9]\{1,3\}\) /\",\1,/' \
  -e 's/\" \"/\",\"/g' \
  -e 's/memory_kb=//g' \
  -e 's/ %cpu=/,/g' \
  -e 's/ duration_ms=/,/g' \
  -e 's/ request_id=/,/g' \
  >>"${OUTPUT_FILE}"

echo "Log entries exported to ${OUTPUT_FILE}"
