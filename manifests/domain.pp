# configure a domain for letsencrypt.sh renewal
define letsencrypt::domain (
    $domain = $title,
    $subdomains = [],
){
    $subdomain_string = join($subdomains, ' ')

    concat::fragment { "letsencrypt_domain_${domain}":
        target  => "${letsencrypt::config_root}/domains.txt",
        content => "${domain} ${subdomain_string}\n",
    }

    file {
        "${letsencrypt::cert_root}/${domain}/":
            ensure  => directory;
    }
    file {
        "${letsencrypt::cert_root}/${domain}/fullchain.pem":
            ensure  => link,
            replace => no,
            target  => "${letsencrypt::cert_root}/placeholders/cert.pem";

        "${letsencrypt::cert_root}/${domain}/privkey.pem":
            ensure  => link,
            replace => no,
            target  => "${letsencrypt::cert_root}/placeholders/key.pem";

        "${letsencrypt::cert_root}/${domain}/combined.pem":
            ensure  => file,
            replace => no,
            source  => 'puppet:///modules/letsencrypt/placeholder_combined.pem';

    } ~> Class['letsencrypt::renew']
}
