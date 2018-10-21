#!/bin/bash

# This script deletes all backups that are older than a month

LIMIT=$(date -d"1 month ago" +%F)

FILES=$(aws s3api list-objects --bucket skyrbackup --query "Contents[?LastModified < '$LIMIT'].[Key]" --output text)

if [[ "$FILES" == "" ]]; then
  # No backup files to clean up
  exit 0
fi

KEYS=""
for file in $FILES; do
  KEYS="$KEYS{\"Key\": \"$file\"},"
done

echo "{\"Objects\": [${KEYS::-1}]}" > /tmp/delete.json

aws s3api delete-objects --bucket skyrbackup --delete file:///tmp/delete.json
rm /tmp/delete.json
