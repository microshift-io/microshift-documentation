HUGO_VERSION := 0.89.4/extended
HOSTNAME := $(shell hostname)
PORT := 8080

.PHONY: server
server: hugo
	./hugo server -w . \
		--bind 0.0.0.0 --port $(PORT) \
		-b http://$(HOSTNAME):$(PORT)

hugo:
	@echo Downloading hugo wrapper
	@curl -L -o hugo https://github.com/khos2ow/hugo-wrapper/releases/download/v1.6.0/hugow
	@chmod +x hugo
	@./hugo --get-version $(HUGO_VERSION)

.PHONY: static
static: hugo
	./hugo -D

.DEFAULT_GOAL := static

.PHONY: clean
clean:
	rm -rf .hugo
	rm -f hugo .hugo_build.lock
