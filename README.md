# Terraform security check action

This action runs https://github.com/liamg/tfsec on `$GITHUB_WORKSPACE`. This is a security check on your terraform repository. 

The action requires the https://github.com/actions/checkout before to download the content of your repo inside the docker. 

## Inputs

* `tfsec_actions_comment` - (Optional) Whether or not to comment on GitHub pull requests. Defaults to `true`.

## Outputs

None

## Example usage

```yaml
steps:
  - uses: actions/checkout@v1
  - uses: triat/terraform-security-scan@v1
```

To allow the action to add a comment to a PR when it fails you need to append the `GITHUB_TOKEN` variable to the tfsec action:

```yaml
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
