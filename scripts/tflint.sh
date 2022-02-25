#!/usr/bin/env bash
echo "Scanning all files(*.tf) with tflint"
find * -name '*.tf' | grep -E -v ".terraform|.terragrunt-cache" | while read -r line; do
    tflint "$line" -f compact
done
