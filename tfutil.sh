#!/bin/bash

# Format the Terraform configuration
terraform fmt

# Generate terraform docs
terraform-docs markdown table --output-file README.md --output-mode inject .

# Lint the Terraform configuration
tflint -f compact

# Generate architecture diagram
terraform graph -draw-cycles | dot -Tpng >graph.png

# IaC security/compliance SCA
checkov --quiet --compact --directory .
