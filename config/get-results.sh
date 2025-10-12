#!/bin/bash

# Store all parameters in an array
endpoint="https://dmoxbartyorai.cognitiveservices.azure.com/"  # e.g., https://my-resource-name-endpoint.cognitiveservices.azure.com/
request_id="0983fe89-a95c-454e-8654-c5517424aba7"  # e.g., 123e4567-e89b-12d3-a456-426614174000

tkn=$(az account get-access-token --resource https://cognitiveservices.azure.com --query accessToken --output tsv)

curl -i -X GET "$endpoint/contentunderstanding/analyzerResults/$request_id?api-version=2025-05-01-preview" \
  -H "Authorization: Bearer $tkn"