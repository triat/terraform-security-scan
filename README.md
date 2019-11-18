# Terraform security check action

This action runs https://github.com/liamg/tfsec on `$GITHUB_WORKSPACE`. This is a security check on your terraform repository. 

The action requires the https://github.com/actions/checkout before to download the content of your repo inside the docker. 

## Inputs

None

## Outputs

None

## Example usage
```
steps:
  - uses: actions/checkout@v1
  - uses: actions/triat/terraform-security-scan@v1
```
