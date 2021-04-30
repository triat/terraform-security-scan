#!/bin/bash

#Select the output format
if [ "${TFSEC_OUTPUT_FILE}" != "" ]; then
  TFSEC_FORMAT="-f ${TFSEC_OUTPUT_FILE}"
else
  TFSEC_FORMAT=""
fi

#select the output file
if [ "${TFSEC_OUTPUT_FILE}" != "" ]; then
  TFSEC_FILE="--out ${TFSEC_OUTPUT_FILE}"
else
  TFSEC_FILE=""
fi

# Comment on the pull request if necessary.
if [ "${INPUT_TFSEC_ACTIONS_WORKING_DIR}" != "" ] && [ "${INPUT_TFSEC_ACTIONS_WORKING_DIR}" != "." ]; then
  TFSEC_WORKING_DIR="/github/workspace/${INPUT_TFSEC_ACTIONS_WORKING_DIR}"
else
  TFSEC_WORKING_DIR="/github/workspace/"
fi

# grab tfsec from GitHub (taken from README.md)
if [[ -n "$INPUT_TFSEC_VERSION" ]]; then
  env GO111MODULE=on go install github.com/tfsec/tfsec/cmd/tfsec@"${INPUT_TFSEC_VERSION}"
else
  env GO111MODULE=on go get -u github.com/tfsec/tfsec/cmd/tfsec
fi

if [[ -n "$INPUT_TFSEC_EXCLUDE" ]]; then
  TFSEC_OUTPUT=$(/go/bin/tfsec ${TFSEC_WORKING_DIR} --no-colour -e "${INPUT_TFSEC_EXCLUDE}" "${TFSEC_FORMAT}" "${TFSEC_FILE}")
else
  TFSEC_OUTPUT=$(/go/bin/tfsec ${TFSEC_WORKING_DIR} --no-colour "${TFSEC_FORMAT}" "${TFSEC_FILE}")
fi
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
${TFSEC_OUTPUT}
\`\`\`

</details>"
  PAYLOAD=$(echo "${COMMENT}" | jq -R --slurp '{body: .}')
  URL=$(jq -r .pull_request.comments_url "${GITHUB_EVENT_PATH}")
  echo "${PAYLOAD}" | curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data @- "${URL}" > /dev/null
fi

exit $TFSEC_EXITCODE
