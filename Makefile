.PHONY: help build serve clean prepare-all install

HUGO := hugo
HUGO_ENV ?= development
NPM := npm

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install Node.js dependencies
	$(NPM) install

prepare-all: ## Prepare all project documentation
	@echo "No projects mounted yet - this will be populated in future phases"
	# Future: @cd ../bindy && make docs-hugo-prepare

build: prepare-all ## Build Hugo site
	@echo "Building Hugo site for $(HUGO_ENV)..."
	@export PATH=/usr/local/go/bin:$$PATH && $(HUGO) --environment $(HUGO_ENV) --minify

serve: prepare-all ## Serve Hugo site locally
	@echo "Starting Hugo server..."
	@export PATH=/usr/local/go/bin:$$PATH && $(HUGO) server --buildDrafts --environment $(HUGO_ENV) --baseURL "http://localhost:1313/"

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf public/ resources/ .hugo_build.lock

test: build ## Run validation tests
	@echo "Running site validation tests..."
	@./test-site.sh
