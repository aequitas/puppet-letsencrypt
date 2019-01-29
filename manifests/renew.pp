# run renew script
class letsencrypt::renew (
    $allow_failure = false
){
    if $allow_failure {
        $command = "${letsencrypt::config_root}/renew.sh || true"
    } else {
        $command = "${letsencrypt::config_root}/renew.sh"
    }

    exec { 'letsencrypt renew':
        command     => $command,
        refreshonly => true,
    }
}
