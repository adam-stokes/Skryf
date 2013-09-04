# Build helpers for skryf

build: css js img
	@milla build

release:
	@milla release

install: build
	@cpanm .

test: install
	TEST_ONLINE=mongodb://localhost:27017/testdb prove -r t

css:
	@scss _includes/stylesheets/style.scss > share/public/stylesheets/style.css
	@scss _includes/stylesheets/style.admin.scss > share/public/stylesheets/style.admin.css
	@cp -a _includes/stylesheets/*.css share/public/stylesheets/.

js:
	@cp -a _includes/javascripts/*.js share/public/javascripts/.

img:
	@cp -a _includes/images/*.png share/public/images/.
