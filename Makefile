.PHONY: preview deploy

preview:
	open index.html

deploy:
	git add -A
	git diff --quiet --cached || git commit -m "Update site"
	git push
