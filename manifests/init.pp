# == Class: letsencrypt
#
# Install and manage letsencrypt.sh
#
# === Parameters
#
# Document parameters here.
#
# [*email*]
#   Email address of administrator (required by letsencrypt).
#
# [*www_root*]
#   Location where vhosts will point to for ".well-known/" requests.
#
# [*config_root*]
#   Location to install letsencrypt.sh.
#
# [*cert_root*]
#   Location to install certificates.
#
# [*staging*]
#   Use letsencrypt staging server instead of live.
#
# === Examples
#
#  class { 'letsencrypt':
#    email   => 'nobody@example.com',
#    staging => true,
#  }
#
# === Authors
#
# Johan Bloemberg <mail@ijohan.nl>
#
# === Copyright
#
# Copyright 2016 Johan Bloemberg
#
class letsencrypt (
    $email       = undef,
    $www_root    = '/var/www/letsencrypt',
    $config_root = '/etc/letsencrypt.sh',
    $cert_root   = '/etc/letsencrypt.sh/certs',
    $staging     = false,
){
    include renew

    validate_string($email)

    ensure_packages(['curl'], {ensure => 'present'})

    File {
        owner  => root,
        group  => root,
    }

    file {
        $config_root:
            ensure => directory;

        "${config_root}/logs":
            ensure => directory;

        "${config_root}/letsencrypt.sh":
            ensure => present,
            source => 'puppet:///modules/letsencrypt/letsencrypt.sh',
            mode   => '0755';

        "${config_root}/renew.sh":
            ensure => present,
            source => 'puppet:///modules/letsencrypt/renew.sh',
            mode   => '0755';

        "${config_root}/config.sh":
            ensure  => present,
            content => template('letsencrypt/config.sh.erb');

        $www_root:
            ensure => directory;

        $cert_root:
            ensure => directory;

        "${cert_root}/placeholders/":
            ensure => directory;

        "${cert_root}/placeholders/cert.pem":
            ensure => file,
            source => 'puppet:///modules/letsencrypt/placeholder_cert.pem';

        "${cert_root}/placeholders/key.pem":
            ensure => file,
            source => 'puppet:///modules/letsencrypt/placeholder_key.pem';
    }

    concat { "${config_root}/domains.txt":
        ensure         => present,
        ensure_newline => true,
    } ~> Class['renew']

    cron { 'letsencrypt-renew':
        command => "${config_root}/renew.sh >/dev/null",
        special => weekly,
    }

    File["${config_root}/config.sh"] ~> Class['renew']
}
