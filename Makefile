build-docs: install-docs
	@echo "To build the documentation, run install-docs first."
	rm -rf dist
	mkdir -p dist
	node docs.js

reflex:
	@echo 'To use this task, `go get github.com/cespare/reflex`'

reflex-docs: reflex install-docs
	# for some reason reflex and the build-docs task don't play nicely
	which reflex &>/dev/null && ulimit -n 2048 && reflex -r 'source/.*\.md' node docs.js

install-docs:
	@echo "To install the packages required for documentation generation, you need npm."
	npm install mdoc
	npm install marked

start-doc-server:
	go run docs-server.go dist &
	@echo "You should now be able to generate and view the docs at http://localhost:8080"

stop-doc-server:
	pkill -f docs-server

publish-docs: build-docs
	cd dist && s3cmd sync --delete-removed --recursive * s3://contiv-docs