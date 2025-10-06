# Description

## Prerequisites

- azure cli installed
- login on azure cli

## IAC - azure resources

Update the dev.tfvars with the prefix the resources will have and the location where the resources will be created.

```sh
cd iac

terrraform init

terraform plan -out plan1

terraform apply plan1
```

## Configurations - custom analyzer

Open the config/create.sh file and update the endpoint with the the ai_service_endpoint that was displayed after applying the terraform plan.

## SRC - extract information

Update the .env ENDPOINT variable file with the the ai_service_endpoint that was displayed after applying the terraform plan

To send the image "src/r2.jpg" to the content understanding run the following commands

```sh
cd src

uv sync

uv run main.py

```