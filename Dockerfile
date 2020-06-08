# pinned version of the Alpine-tagged 'go' image
FROM golang:1.13-alpine

# install requirements
RUN apk add --update --no-cache bash ca-certificates curl jq

# grab tfsec from GitHub (taken from README.md)
RUN env GO111MODULE=on go get -u github.com/liamg/tfsec/cmd/tfsec@v0.19.0

COPY entrypoint.sh /entrypoint.sh
# set the default entrypoint -- when this container is run, use this command
ENTRYPOINT ["/entrypoint.sh"]
