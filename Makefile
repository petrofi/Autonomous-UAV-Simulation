.PHONY: help check-whitespace show-structure

help:
	@echo "Available targets:"
	@echo "  help              Show this help message"
	@echo "  check-whitespace  Run Git whitespace validation"
	@echo "  show-structure    Display the repository structure"

check-whitespace:
	@git diff --check

show-structure:
	@if command -v tree >/dev/null 2>&1; then tree -a -I .git; else find . -path './.git' -prune -o -print; fi
