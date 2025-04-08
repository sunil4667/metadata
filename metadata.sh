#!/bin/bash

# Get IMDSv2 token
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Exit if token fetch failed
if [ -z "$TOKEN" ]; then
  echo "Failed to retrieve IMDSv2 token"
  exit 1
fi

# Fetch metadata using the token
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

INSTANCE_TYPE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-type)

AVAILABILITY_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Output as JSON
echo "{
  \"instance_id\": \"$INSTANCE_ID\",
  \"instance_type\": \"$INSTANCE_TYPE\",
  \"availability_zone\": \"$AVAILABILITY_ZONE\"
}"

