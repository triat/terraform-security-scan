#!/bin/bash

# Comment on the pull request if necessary.
if [ "${INPUT_TFSEC_ACTIONS_WORKING_DIR}" != "" ] && [ "${INPUT_TFSEC_ACTIONS_WORKING_DIR}" != "." ]; then
  TFSEC_WORKING_DIR="/github/workspace/${INPUT_TFSEC_ACTIONS_WORKING_DIR}"
else
  TFSEC_WORKING_DIR="/github/workspace/"
fi

TFSEC_OUTPUT=$(/go/bin/tfsec ${TFSEC_WORKING_DIR})
TFSEC_EXITCODE=${?}

# Exit code of 0 indicates success.
if [ ${TFSEC_EXITCODE} -eq 0 ]; then
  TFSEC_STATUS="Success"
else
  TFSEC_STATUS="Failed"
fi

# Print output.
echo "${TFSEC_OUTPUT}"

# Comment on the pull request if necessary.
if [ "${INPUT_TFSEC_ACTIONS_COMMENT}" == "1" ] || [ "${INPUT_TFSEC_ACTIONS_COMMENT}" == "true" ]; then
  TFSEC_COMMENT=1
else
  TFSEC_COMMENT=0
fi

if [ "${GITHUB_EVENT_NAME}" == "pull_request" ] && [ -n "${GITHUB_TOKEN}" ] && [ "${TFSEC_COMMENT}" == "1" ] && [ "${TFSEC_EXITCODE}" != "0" ]; then
    COMMENT="#### \`Terraform Security Scan\` ${TFSEC_STATUS}
<details><summary>Show Output</summary>

\`\`\`hcl
$(/go/bin/tfsec /github/workspace --no-colour)
\`\`\`

</details>"
  PAYLOAD=$(echo "${COMMENT}" | jq -R --slurp '{body: .}')
  URL=$(jq -r .pull_request.comments_url "${GITHUB_EVENT_PATH}")
  echo "${PAYLOAD}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${URL}" > /dev/null
fi

exit $TFSEC_EXITCODE
