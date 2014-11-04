SHELL := /usr/bin/env bash

release-major:
	npm version major -m "Release %s"
	git push
	npm publish

release-minor:
	npm version minor -m "Release %s"
	git push
	npm publish

release-patch:
	npm version patch -m "Release %s"
	git push
	npm publish
