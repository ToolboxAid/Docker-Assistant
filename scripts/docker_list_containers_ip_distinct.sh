#!/bin/bash

# Get the list of running containers
CONTAINERS=$(docker ps --format '{{.ID}} {{.Names}}')

# Print the header row
echo "Container ID | Container Name | Network | IP Address"

# Declare an array to hold all IP addresses
declare -a ALL_IP_ADDRESSES

# Iterate over each container in the output
while read -r line; do
  CONTAINER_ID=$(echo $line | awk '{print $1}')
  CONTAINER_NAME=$(echo $line | awk '{print $2}')

  # Skip empty lines
  if [[ -z "$CONTAINER_ID" ]]; then
    continue
  fi

  # Get the IP addresses and network names using the 'inspect' command
  IP_ADDRESSES=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}, {{end}}' $CONTAINER_ID)
  NETWORK_NAMES=$(docker inspect -f '{{range $k, $v := .NetworkSettings.Networks}}{{$k}}, {{end}}' $CONTAINER_ID)

  # Remove trailing comma and space
  IP_ADDRESSES=${IP_ADDRESSES%, }
  NETWORK_NAMES=${NETWORK_NAMES%, }

  # Add IP addresses to the array
  IFS=', ' read -r -a ADDR_ARRAY <<< "$IP_ADDRESSES"
  ALL_IP_ADDRESSES+=("${ADDR_ARRAY[@]}")

  # Print the container information along with its IP address
  echo "$CONTAINER_ID | $CONTAINER_NAME | $NETWORK_NAMES | $IP_ADDRESSES"
done <<< "$CONTAINERS"

# Function to replace the last node of an IP address with "xxx"
replace_last_node() {
  local ip="$1"
  local ip_prefix="${ip%.*}"
  echo "$ip_prefix.xxx"
}

# Use an associative array (like a set) to keep track of unique IPs
declare -A UNIQUE_IPS

# Transform the IP addresses and store them in the associative array
for ip in "${ALL_IP_ADDRESSES[@]}"; do
  transformed_ip=$(replace_last_node "$ip")
  UNIQUE_IPS["$transformed_ip"]=1
done

# Print the distinct list of IP addresses with the last node replaced
echo
echo "Distinct IP Addresses (with last node replaced):"
for ip in "${!UNIQUE_IPS[@]}"; do
  echo "$ip"
done | sort

