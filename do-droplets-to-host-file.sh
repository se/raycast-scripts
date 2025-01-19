#!/bin/bash

# DigitalOcean Token
DO_TOKEN=$DO_TOKEN_MONOFOR

# DigitalOcean API URL
DO_API_URL="https://api.digitalocean.com/v2/droplets"

# Hosts file
HOSTS_FILE="/etc/hosts"

# Start and end tags
START_TAG="# <Monofor - Digital Ocean>"
END_TAG="# </Monofor - Digital Ocean>"

# Fetch all droplets from DigitalOcean
droplets=$(curl -s -X GET -H "Content-Type: application/json" \
	-H "Authorization: Bearer $DO_TOKEN" "$DO_API_URL")

# Check if curl was successful
if [ $? -ne 0 ]; then
	echo "Failed to fetch droplet information. Check your token or network connection."
	exit 1
fi

# Extract relevant information (name and IP address)
droplet_info=$(echo "$droplets" | jq -r '.droplets[] | "\(.name) \(.networks.v4[] | select(.type == "public").ip_address)"')

# Backup the existing /etc/hosts file with a timestamp
backup_file="${HOSTS_FILE}.$(date +%Y%m%d%H%M%S).bak"
sudo cp $HOSTS_FILE $backup_file

# Notify user about the backup
echo "Backup of /etc/hosts created at $backup_file"

# Remove old section between tags if it exists using awk
awk -v start="$START_TAG" -v end="$END_TAG" '
  $0 == start {in_block=1}
  $0 == end {in_block=0; next}
  !in_block {print}
' $HOSTS_FILE | sudo tee $HOSTS_FILE.tmp >/dev/null

# Create a temporary file for updated entries
temp_file=$(mktemp)

# Add custom tags and entries
{
	echo "$START_TAG"
	while read -r name ip; do
		if [[ -z "$ip" ]]; then
			continue
		fi

		# Add prefix 'do-' if not present
		if [[ "$name" != do-* ]]; then
			name="do-$name"
		fi

		echo "$ip $name"
	done <<<"$droplet_info"
	echo "$END_TAG"
} >"$temp_file"

# Append the updated entries with tags to the hosts file
cat "$temp_file" | sudo tee -a $HOSTS_FILE.tmp >/dev/null

# Replace original hosts file
sudo mv $HOSTS_FILE.tmp $HOSTS_FILE

# Clean up
rm -f "$temp_file"

echo "Hosts file updated successfully between $START_TAG and $END_TAG!"
