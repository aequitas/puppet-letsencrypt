.PHONY: check fix
fix:
	puppet-lint --fix manifests

check:
	puppet-lint manifests

update:
	curl -s -o files/letsencrypt.sh \
		https://raw.githubusercontent.com/lukas2511/letsencrypt.sh/master/letsencrypt.sh

placeholders: files/placeholder_cert.pem files/placeholder_key.pem files/placeholder_combined.pem

files/placeholder_cert.pem files/placeholder_key.pem:
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
		-keyout files/placeholder_key.pem \
		-out files/placeholder_cert.pem

files/placeholder_combined.pem: files/placeholder_key.pem files/placeholder_cert.pem
	cat $^ > $@

clean_placeholders:
	rm -f files/placeholder_*