deps:
	bower install
	npm install -d

build:
	mkdir -p build/js
	mkdir -p build/css
	@./node_modules/.bin/uglifyjs --comments \
	-o build/js/bootstrap-switch.min.js \
	src/js/bootstrap-switch.js
	@./node_modules/.bin/lessc --yui-compress \
	src/less/bootstrap-switch.less \
	build/css/bootstrap-switch.min.css

clean:
	rm -rf build

.PHONY: deps build clean
