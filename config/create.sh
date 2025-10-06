#!/bin/bash

# Store all parameters in an array
endpoint="AI_RESOURCE_ENDPOINT"  # e.g., https://my-resource-name-endpoint.cognitiveservices.azure.com/

analyzerId="my-custom-nlzr"
tkn=$(az account get-access-token --resource https://cognitiveservices.azure.com --query accessToken --output tsv)

url="$endpoint/contentunderstanding/analyzers/$analyzerId?api-version=2025-05-01-preview"
echo $url

curl -i -X PUT "$endpoint/contentunderstanding/analyzers/$analyzerId?api-version=2025-05-01-preview" \
  -H "Authorization: Bearer $tkn" \
  -H "Content-Type: application/json" \
  -d @custom_analyzer.json