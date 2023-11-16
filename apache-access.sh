#!/usr/bin/env bash

# Parse an apache-access log file into CSV for easier analysis.
# usage log-analysis-apache-access.sh /path/to/logfile.txt
# Format based on https://docs.acquia.com/cloud-platform/monitor/logs/apache-access/

# Credit to dovidev and kaefert: https://stackoverflow.com/questions/11707865/get-apache-logs-as-csv-file/54371124

# Get the directory that the script is in, no matter where it has been called from.
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

LOG_FILE=$1

DATE=$(date "+%Y-%m-%d_%H-%M")

OUTPUT_FILE="${SCRIPT_DIR}/log-analysis-apache-access-${DATE}.csv"

echo "IP address,Identity,User name,Date,Time,Method,Path,Protocol,Status Code,Response size,Referrer,User Agent,vhost,host,hosting_site,Process ID,Request Time,Forwarded for,Request ID,Location" >"${OUTPUT_FILE}"

# If there is no IP address, wrap the dash in quotes and add a comma
# Replace all commas with spaces
# Parse the IP address
# Put commas after identity and user name - TODO: this only handles dashes in these fields
# Parse the date and time
# Remove the timezone offset
# Wrap the HTTP method in quotes if it is GET
# Wrap the HTTP method in quotes if it is OPTIONS
# Wrap the HTTP method in quotes if it is POST - TODO: combine these three lines into one regex
# Parse the HTTP protocol, status code and response size
# Convert all spaces between quotes into commas
# Remove vhost prefix
# Remove host prefix
# Remove hosting_site prefix
# Remove pid prefix
# Remove request_time prefix
# Remove forwarded_for prefix
# Remove request_id prefix
# Remove location prefix 
cat "${LOG_FILE}" | sed -e 's/^- /\"-\",/' \
  -e 's/,/ /g' \
  -e 's/\([0-9]\{1,3\}\.\)\([0-9]\{1,3\}\.\)\([0-9]\{1,3\}\.\)\([0-9]\{1,3\}\)/\"\1\2\3\4\",/' \
  -e 's/\( -\)\( -\) /\1,\2,/' \
  -e 's/\[\([0-9]\{2\}\)\/\(...\)\/\"\([0-9]\{4\}\):/\1 \2 \3\",/' \
  -e "s/ $(date +%z)\] /,/" \
  -e 's/\"GET /\"GET\",\"/' \
  -e 's/\"OPTIONS /\"OPTIONS\",\"/' \
  -e 's/\"POST /\"POST\",\"/' \
  -e 's/ HTTP\/1.1\" \([0-9]\{1,3\}\) \([-0-9]\{1,\}\)/\",\"HTTP\/1.1\",\1,\2,/' \
  -e 's/\" \"/\",\"/g' \
  -e 's/ vhost=/,/g' \
  -e 's/ host=/,/g' \
  -e 's/ hosting_site=/,/g' \
  -e 's/ pid=/,/g' \
  -e 's/ request_time=/,/g' \
  -e 's/ forwarded_for=/,/g' \
  -e 's/ request_id=/,/g' \
  -e 's/ location=/,/g' \
  >>"${OUTPUT_FILE}"

echo "Log entries exported to ${OUTPUT_FILE}"
