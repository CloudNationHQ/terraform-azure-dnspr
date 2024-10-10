.PHONY: test docs fmt validate install-tools

export EXAMPLE

all: install-tools validate fmt docs

install-tools:
	@go install github.com/terraform-docs/terraform-docs@latest

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(EXAMPLE) ./deploy_test.go

docs:
	terraform-docs markdown . --output-file README.md --output-mode inject

fmt:
	terraform fmt -recursive

validate:
	terraform init -backend=false
	terraform validate
	@echo "Cleaning up initialization files..."
	@rm -rf .terraform
	@rm -f terraform.tfstate
	@rm -f terraform.tfstate.backup
	@rm -f .terraform.lock.hcl

