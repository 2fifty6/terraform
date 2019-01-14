#!/bin/bash -ex
[[ -d .terraform ]] && rm -rf .terraform

# NOTE: requires terraform v....0.10? maybe 0.9
# Set expiration date for resource tags
EXPIRATION_DATE=`date -u -d '3 months' '+%Y%m%d %H:%M:%S %Z'`
SCALING_MIN=1
SCALING_MAX=1
# s3
STATE_BUCKET="some-bucket"
STATE_KEY="path/in/bucket"
VPC_STATE_KEY="path/in/bucket"

terraform init -get=true \
  -backend-config="region=$REGION" \
  -backend-config="bucket=$STATE_BUCKET" \
  -backend-config="key=$STATE_KEY"

terraform $OPERATION \
  -var account_id="$aws_account_id" \
  -var "stack=\"$STACK\"" \
  -var remote_state_bucket="$STATE_BUCKET" \
  -var vpc_state_key="$VPC_STATE_KEY" \
  -var aws_key_name="$KEY_NAME" \
  -var region="$REGION" \
  -var input_cidrs="$INPUT_CIDRS" \
  -var "scaling_min=\"$SCALING_MIN\"" \
  -var "scaling_max=\"$SCALING_MAX\"" \
  -var expiration="$EXPIRATION_DATE"
