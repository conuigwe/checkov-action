# Container image that runs your code
#FROM alpine:3.10
FROM python:slim

RUN apt-get update
RUN apt install -y git

# Install checkov
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY checkov-problem-matcher.json /usr/local/lib/checkov-problem-matcher.json
COPY checkov-problem-matcher-softfail.json /usr/local/lib/checkov-problem-matcher-softfail.json

COPY rules/failure.txt /failure.txt
COPY rules/warnings.txt /warnings.txt

RUN warnings_rule="$(cat /warnings.txt | paste -sd ",")" >> $GITHUB_ENV

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
