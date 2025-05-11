# Base image
FROM golang:1.24.2-alpine3.21

# ARGs
ARG SEMGREP_VERSION=1.120.0
ARG TRIVY_VERSION=0.61.1
ARG PYTHON3_VERSION=3.12.10-r0
ARG PIP_VERSION=24.3.1-r0
ARG GIT_VERSION=2.47.2-r0
ARG CURL_VERSION=8.12.1-r1
ARG JQ_VERSION=1.7.1-r0

# Set pip environment
ENV PIP_ROOT_USER_ACTION=ignore

# Update package manager and install pinned versions
RUN apk update && apk add --no-cache \
    python3=${PYTHON3_VERSION} \
    py3-pip=${PIP_VERSION} \
    git=${GIT_VERSION} \
    curl=${CURL_VERSION} \
    jq=${JQ_VERSION}

# Install Semgrep
RUN pip install semgrep==${SEMGREP_VERSION} --break-system-packages --root-user-action=ignore

# Install Trivy
RUN curl -L https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -o trivy.tar.gz \
    && tar zxvf trivy.tar.gz \
    && mv trivy /usr/local/bin/ \
    && rm -f trivy.tar.gz

# Set working directory
WORKDIR /app

# Default entrypoint
CMD ["/bin/sh"]