FROM debian:bullseye

RUN apt update -y && apt install -y curl jq bc git

COPY . /code

WORKDIR /code

ENV DATA_DIR="/git"
ENV GITHUB_TYPE="orgs"
ENV GITHUB_ORG="orgever"

CMD ["/code/run.sh"]
