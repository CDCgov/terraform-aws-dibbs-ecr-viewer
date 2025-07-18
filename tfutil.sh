#!/bin/bash

terraform fmt
terraform-docs markdown table --output-file README.md --output-mode inject .
tflint -f compact
terraform graph -draw-cycles | dot -Tpng >graph.png
