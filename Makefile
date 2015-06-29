SHELL := /usr/bin/env bash

.PHONY: release-major
release-major:
	npm version major -m "Release %s"
	git push
	npm publish

.PHONY: release-minor
release-minor:
	npm version minor -m "Release %s"
	git push
	npm publish

.PHONY: release-patch
release-patch:
	npm version patch -m "Release %s"
	git push
	npm publish
