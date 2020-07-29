# Terraform security check action

This action runs https://github.com/liamg/tfsec on `$GITHUB_WORKSPACE`. This is a security check on your terraform repository.

The action requires the https://github.com/actions/checkout before to download the content of your repo inside the docker.

## Inputs

* `tfsec_actions_comment` - (Optional) Whether or not to comment on GitHub pull requests. Defaults to `true`.
* `tfsec_actions_working_dir` - (Optional) Terraform working directory location. Defaults to `'.'`.
* `tfsec_exclude` - (Optional) Provide checks via `,` without space to exclude from run. No default
* `tfsec_version` - (Optional) Specify the version of tfsec to install. Defaults to the latest

## Outputs

None

## Example usage

```yaml
steps:
  - uses: actions/checkout@v2
  - uses: triat/terraform-security-scan@v1
```
The above example uses a tagged version (`v1`), you can also opt to use any of the released version.

To allow the action to add a comment to a PR when it fails you need to append the `GITHUB_TOKEN` variable to the tfsec action:

```yaml
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Full example:

```yaml
jobs:
  tfsec:
    name: tfsec
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Terraform security scan
        uses: triat/terraform-security-scan@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
