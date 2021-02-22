# pinned version of the Alpine-tagged 'go' image
FROM golang:1.16-alpine

# install requirements
RUN apk add --update --no-cache bash ca-certificates curl jq

COPY entrypoint.sh /entrypoint.sh
# set the default entrypoint -- when this container is run, use this command
ENTRYPOINT ["/entrypoint.sh"]
