.PHONY: check fix
fix:
	puppet-lint --fix manifests

check:
	puppet-lint manifests

update:
	curl -s -o files/letsencrypt.sh \
		https://raw.githubusercontent.com/lukas2511/letsencrypt.sh/master/letsencrypt.sh
