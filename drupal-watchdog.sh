#!/usr/bin/env bash

# Parse a drupal-watchdog log file into CSV for easier analysis.
# usage log-analysis-drupal-watchdog.sh /path/to/logfile.txt
# Format based on https://docs.acquia.com/cloud-platform/monitor/logs/drupal-watchdog/

# Get the directory that the script is in, no matter where it has been called from.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LOG_FILE=$1

DATE=$(date "+%Y-%m-%d")

OUTPUT_FILE="${SCRIPT_DIR}//log-analysis-drupal-watchdog-${DATE}.csv"

echo "Time,Timestamp,Type,IP address,Location,Referer,User ID,Message," > ${OUTPUT_FILE}

# Remove lines without timestamps | remove server info | remove request ID  | Output to CSV.
cat "${LOG_FILE}" | grep dxp01 | sed 's/ drupal-.*dxp/\|dxp/' | sed 's/request_id=.*//' | awk -F "|" '{ print $1","$3","$4","$5","$6","$7","$8",\""$10"\"" }' >> ${OUTPUT_FILE}

echo "Log entries exported to ${OUTPUT_FILE}"
