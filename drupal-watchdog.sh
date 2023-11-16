#!/usr/bin/env bash

# Parse a drupal-watchdog log file into CSV for easier analysis.
# usage log-analysis-drupal-watchdog.sh /path/to/logfile.txt
# Format based on https://docs.acquia.com/cloud-platform/monitor/logs/drupal-watchdog/

# Get the directory that the script is in, no matter where it has been called from.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

LOG_FILE=$1

DATE=$(date "+%Y-%m-%d_%H-%M")

OUTPUT_FILE="${SCRIPT_DIR}/log-analysis-drupal-watchdog-${DATE}.csv"

echo "Date/Time,Timestamp,Type,IP address,Location,Referer,User ID,Message," >${OUTPUT_FILE}

# Remove lines without dates at the start
# Remove server info
# Replace double quotes with single quotes 
# Remove request ID prefix
# Only keep relevant parts, split by |.
# Output to CSV.
cat "${LOG_FILE}" | 
  grep "^[a-zA-Z][a-zA-Z][a-zA-Z] " |
  sed -e 's/ \(drupal-.*: \)/\|\1/' \
    -e "s/\"/'/g" \
    -e 's/request_id=//' |
  awk -F "|" '{ print $1","$3","$4","$5","$6","$7","$8",\""$10"\"" }' \
    >>${OUTPUT_FILE}

echo "Log entries exported to ${OUTPUT_FILE}"
