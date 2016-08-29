.PHONY: check fix
fix:
	puppet-lint --fix manifests

check:
	puppet-lint manifests
