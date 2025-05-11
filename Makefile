# Auto-detect GitHub details
GITHUB_REPO_URL=$(shell git config --get remote.origin.url)
GITHUB_ORG_NAME=$(shell echo $(GITHUB_REPO_URL) | sed -E 's/.*[:\/](.*)\/(.*)\.git/\1/')
APP_NAME=$(shell echo $(GITHUB_REPO_URL) | sed -E 's/.*[:\/](.*)\/(.*)\.git/\2/')
VERSION=0.1.0
IMAGE=ghcr.io/$(GITHUB_ORG_NAME)/$(APP_NAME)

# Build Docker image
build:
	docker build -t $(APP_NAME):$(VERSION) -f docker/Dockerfile .

# Start interactive shell inside built container
shell:
	docker run -it --rm -v $(PWD):/app -w /app $(APP_NAME):$(VERSION)

# Tag Docker image for registry upload
tag:
	docker tag $(APP_NAME):$(VERSION) $(IMAGE):$(VERSION)
	docker tag $(APP_NAME):$(VERSION) $(IMAGE):latest

# Push Docker image to GHCR
push:
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest

# Run Go unit tests inside container
test-container:
	docker run --rm -v $(PWD):/app -w /app $(APP_NAME):$(VERSION) go test ./...

# Run Semgrep scanner standalone
test-sast:
	semgrep --config=auto --json --output semgrep-test.json ./testdata

# Run Trivy scanner standalone
test-trivy:
	trivy image --format json --output trivy-test.json alpine:latest

# Full app scan
test-app:
	go build -o scanner ./cmd/scanner
	./scanner --mode sast --path ./testdata
	./scanner --mode container --image alpine:latest