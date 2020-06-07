---
title: MAKE the Blog - Use GNU Make to Automate Jekyll
date: 2020-05-26 19:30:00 +01:00
description: Some Jekyll, web hosting and make scripts.
category: Behind-the-Blog
tags: gnu-make, automation, blog, jekyll
---
There is a lot of work involved in getting Jekyll blog posts published to a server. You have to preview it for proofreading and editing, you have to build it, and in the end you also have to get the finished site onto a web server.

Some of the commands required are easy to handle. For example, building the Jekyll output is a simple `@bundler exec jekyll build`.

On the other hand, the upload and syncing of the site to the web server looks like this:
```
>> @rsync -avrz --delete-excluded                  \
    --rsh=ssh _site/*                              \
    ssh-user_xxxxx@ssh-web-server_xxxxx:./main     
```

Especially the SSH address is a problem here. In a lot of cases, the username and server-address to access webspaces are randomized alphanumeric strings like `user0237481@ssh10437502.best-webspace.io`. Not exactly easy to remember and type out.

The solution: A makefile to automate all of it. You will not need to remember anything again apart of a few simple command options.

Without further ado, here is mine:

{% raw %}
```make
include makefile_credentials

build:
  @bundler exec jekyll build

push:
  @rsync -avrz --delete-excluded --rsh=ssh _site/* $(ssh_user)@$(ssh_server):./main

serve:
  @bundler exec jekyll serve

serve-future:
  @bundler exec jekyll serve --future

deploy: build push
```
{% endraw %}

Some explanations from top to bottom:

1. For obvious security reasons the username and server adress are not directly written in here. Instead, they are both imported from another local text file *(makefile_credentials)* that is explicitly excluded from being tracked and stored in the repository.
2. The `build`option is rarely used by itself. Most often it is used together with `push` to form the `deploy` option.
3. `Rsync` is the preferred command to push the output of the build. It makes sure that the site on the host server is always up to date, including deletions. The SSH connection for `rsync` is secured by a passphrase.
4. The `serve` option directly calls Jekyll's `serve`. Nothing fancy here.
5. The option `serve-future` is basically the same but allows the preview of posts that are scheduled for a later point in time.
6. The last option is the most used for deploying the site to the host server.

In the end, a typical workflow would be:

1. Write a post or make some changes to the layouts, stylings, etc.
2. Preview with `make serve` and do corrections if necessary.
3. Build and upload to the internet with `make deploy` and have a beer in the time you freed up with automation.

&#x1F916;
