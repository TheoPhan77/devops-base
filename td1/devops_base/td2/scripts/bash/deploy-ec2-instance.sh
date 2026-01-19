#!/usr/bin/env bash
set -e
export AWS_DEFAULT_REGION="us-east-2"

INSTANCE_COUNT=2   # ou 3, 5...

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
user_data=$(cat "$SCRIPT_DIR/user-data.sh")

# Create or reuse the security group
security_group_id=$(aws ec2 describe-security-groups \
  --group-names "sample-app" \
  --output text \
  --query 'SecurityGroups[0].GroupId' 2>/dev/null | tr -d '\r')

if [ -z "$security_group_id" ]; then
  security_group_id=$(aws ec2 create-security-group \
    --group-name "sample-app" \
    --description "Allow HTTP traffic into the sample app" \
    --output text \
    --query GroupId | tr -d '\r')
fi

# Allow inbound HTTP traffic (skip if rule already exists)
if ! aws ec2 authorize-security-group-ingress \
  --group-id "$security_group_id" \
  --protocol tcp \
  --port 80 \
  --cidr "0.0.0.0/0" > /dev/null 2>&1; then
  echo "Ingress rule already exists or could not be added, continuing..."
fi

# Launch the EC2 instance
instance_id=$(aws ec2 run-instances \
--image-id "ami-0900fe555666598a2" \
--instance-type "t3.micro" \
--security-group-ids "$security_group_id" \
--user-data "$user_data" \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=sample-app}]' \
--count "$INSTANCE_COUNT" \
--output text \
--query 'Instances[*].InstanceId' | tr -d '\r')

# Wait for the instance to be in running state
aws ec2 wait instance-running --instance-ids $instance_ids

# Get the public IP addresses
public_ips=$(aws ec2 describe-instances \
  --instance-ids $instance_ids \
  --output text \
  --query 'Reservations[*].Instances[*].PublicIpAddress')

echo "Instance IDs = $instance_ids"
echo "Security Group ID = $security_group_id"
echo "Public IPs = $public_ips"