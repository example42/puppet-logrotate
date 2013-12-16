# Define: logrotate::file
#
# This define has beed adapted from:
# https://github.com/arioch/puppet-logrotate/blob/master/manifests/file.pp
#
# [*log*]
#   Path(s) of the log(s) to refer into the logrotate file.
#   Can be an array. Required.
#
# [*options*]
#   Logrotate options for this log. Must be an array.
#   Default: [ 'weekly', 'compress', 'rotate 7', 'missingok' ],
#
# [*prerotate*]
#   Optional prerotate script.
#
# [*postrotate*]
#   Optional postrotate script.
#
# [*template*]
#   Sets an alternative template to use as content for conf file
#   Default: logrotate/conf.erb
#
# [*ensure*]
#   Defines if the file has to be present or absent. Default: present
#   Note that if you set absent => true on the main logrotate class
#   this value is automatically forced to absent
#
define logrotate::conf (
  $log,
  $options    = [ 'weekly', 'compress', 'rotate 7', 'missingok' ],
  $prerotate  = 'NONE',
  $postrotate = 'NONE',
  $template   = 'logrotate/conf.erb',
  $ensure     = present ) {

  require logrotate

  $real_ensure = $logrotate::bool_absent ? {
    true  => 'absent',
    false => $ensure,
  }

  file { "logrotate_conf_${name}":
    ensure  => $real_ensure,
    path    => "${logrotate::config_dir}/${name}",
    mode    => $logrotate::config_file_mode,
    owner   => $logrotate::config_file_owner,
    group   => $logrotate::config_file_group,
    require => Package['logrotate'],
    content => template($template),
    audit   => $logrotate::manage_audit,
    noop    => $logrotate::noops,
  }

}
