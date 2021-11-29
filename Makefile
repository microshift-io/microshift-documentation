
URL := http://localhost:1313
OPEN_CMD := $(shell command -v open || command -v xdg-open || echo : 2>/dev/null)
HUGO_VERSION := 0.89.4/extended
OUTPUT_DIR:=/

hugo:
	@echo Downloading hugo wrapper
	@curl -L -o hugo https://github.com/khos2ow/hugo-wrapper/releases/download/v1.6.0/hugow
	@@chmod +x hugo
	@./hugo --get-version $(HUGO_VERSION)

server: hugo
	(sleep 2; $(OPEN_CMD) $(URL)) &
	./hugo server -w .

static: hugo
	./hugo -D


.DEFAULT_GOAL := static

.PHONY: static server
