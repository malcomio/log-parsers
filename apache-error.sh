#!/usr/bin/env bash

# Parse an apache-error log file into CSV for easier analysis.
# usage log-analysis-apache-error.sh /path/to/logfile.txt
# Format based on https://docs.acquia.com/cloud-platform/monitor/logs/apache-error/

# Get the directory that the script is in, no matter where it has been called from.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LOG_FILE=$1

DATE=$(date "+%Y-%m-%d")

OUTPUT_FILE="${SCRIPT_DIR}//log-analysis-apache-error-${DATE}.csv"

echo "Time,Process,IP address,URL,User Agent,vhost,Forwarded for,Request ID,Message," > ${OUTPUT_FILE}

# Filter for errors | prepare fields for use in CSV columns  | Output to CSV.
cat "${LOG_FILE}" | grep error | sed 's/\[/\|/gp' | sed 's/\] /\|/gp' | sed 's/ "/\|/gp' | sed 's/" /\|/gp' | sed 's/pid=/\|/gp' | sed 's/vhost=/\|/gp' | sed 's/ forwarded_for=/\|/gp' | sed 's/request_id=\"/\|/gp' | sed 's/hosting_site=dxp01 //gp' | awk -F "|" '{ print $2$6","$7","$8",\""$9",\""$10"\","$12","$13"\","$15","$16","$17 }' >> ${OUTPUT_FILE}

echo "Log entries exported to ${OUTPUT_FILE}"
