# vim: set tabstop=8 softtabstop=8 noexpandtab:
all:

buildimage:
	docker build -f Containerfile  -t vitexsoftware/multiflexi-mtr:latest .

buildx:
	docker buildx build  -f Containerfile  . --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag vitexsoftware/multiflexi-mtr:latest

drun:
	docker run --env-file example.env vitexsoftware/multiflexi-mtr:latest

.PHONY: validate-multiflexi-app
validate-multiflexi-app: ## Validates the multiflexi JSON
	@if [ -d multiflexi ]; then \
		for file in multiflexi/*.multiflexi.app.json; do \
			if [ -f "$$file" ]; then \
				echo "Validating $$file"; \
				multiflexi-cli app validate-json --file="$$file"; \
			fi; \
		done; \
	else \
		echo "No multiflexi directory found"; \
	fi
