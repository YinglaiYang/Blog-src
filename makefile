include makefile_credentials

build:
	@bundler exec jekyll build

push:
	@rsync -avrz --delete-excluded --rsh=ssh _site/* $(ssh_user)@$(ssh_server):./main

serve:
	@bundler exec jekyll serve

deploy: build push
