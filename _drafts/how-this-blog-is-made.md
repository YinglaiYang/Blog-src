---
title: How this Blog is Made
date: 2020-05-09 20:30:00 +01:00
description: Some Jekyll, web hosting and make scripts.
---
*This is a living post and will be updated over time.*

Here is a short summary of the machinery behind this blog:
- Yangminded runs on Jekyll. It is using the "Made" theme with slight modifications.
- A simple webhosting service provides access to the public. New content is uploaded to the server from my local computer using `rsync` and `ssh`.
- For simplification of the complete process, I have written a Makefile that is based on (insert website here).



# Process Steps
## Writing
Writing posts and pages for projects follows the standard Jekyll procedure. First, I start with Markdown files in the folder `_drafts`.

When the content is ready, I move them to the `posts` or `pages` folder.

## Proofreading and Checking the Look
It is very important to do both proofreading and also check the general appearance of the content in web browsers.

For proofreading I still need to find a process. When I have something that I am comfortable with, the steps will be added in here.

To check the general appearance of the content in web browsers, I mainly use Safari. Two features are very helpful:

1. Empty Cache
2. Responsive Design

You need to "Empty Cache" to make sure that changes to CSS, icons and similar content will show up in the browser.

"Responsive Design" is necessary to check how the pages will look on other devices with different screen sizes and aspect ratios. The main categories are smartphones (portrait, landscape), tablets (portrait, landscape), desktops with smaller resolution.
