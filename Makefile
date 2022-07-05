.SHELLFLAGS += -x -e
PWD = $(shell pwd)
UID = $(shell id -u)
GID = $(shell id -g)

all: clean build

clean:
	rm -f *.go
	rm -rf docs/

build:
	docker run \
		--rm -v ${PWD}:/local \
		--user ${UID}:${GID} \
		openapitools/openapi-generator-cli:v6.0.0 generate \
		-i api/swagger.json \
		-g go \
		-o /local \
		-c /local/config.yaml \
		--skip-validate-spec
	go get
	go fmt .
	go mod tidy
	rm -f .travis.yml
