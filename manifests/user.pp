# == Class: influxdb::user
#
define influxdb::user (
  Enum['absent', 'present'] $ensure = present,
  $db_user                          = $title,
  $passwd                           = undef,
  $is_admin                         = false,
  $cmd                              = 'influx -execute'
) {
  if ($ensure == 'absent') {
    exec { "drop_user_${db_user}":
      path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
      command => "${cmd} 'DROP USER \"${db_user}\"'",
      onlyif  => "${cmd} 'SHOW USERS' | tail -n+3 | grep ${db_user}"
    }
  } elsif ($ensure == 'present') {
    $arg_p = "WITH PASSWORD '${passwd}'"
    if $is_admin {
      $arg_a = 'WITH ALL PRIVILEGES'
    } else {
      $arg_a = ''
    }
    exec { "create_user_${db_user}":
      path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
      command => "${cmd} \"CREATE USER \\\"${db_user}\\\" ${arg_p} ${arg_a}\"",
      unless  => "${cmd} 'SHOW USERS' | tail -n+3 | grep ${db_user}"
    }
  }
}
# EOF
