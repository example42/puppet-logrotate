# = Define: logrotate::file
#
# This defines allows the addition of a single configuration file
# in logrotate.d with the contante you want
# You can use this as an alternative to logrotate::conf and logrotate::rule
#
# == Parameters
#
# [*source*]
#   Sets the content of source parameter for the conf file
#   If defined, logrotate conf file will have the param: source => $source
#
# [*template*]
#   Sets the path to the template to use as content for conf file
#   If defined, logrotate conf file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#
# [*ensure*]
#   Defines if the file has to be present or absent. Default: present
#
# == Usage
# logrotate::file { "apache": source => 'puppet:///modules/site/logrotate/apache' }
# or
# logrotate::file { "apache": content => 'template('site/logrotate/apache')' }
#
define logrotate::file (
  $source  = '' ,
  $content = '' ,
  $ensure  = present ) {

  include logrotate

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $content ? {
    ''        => undef,
    default   => $content,
  }

  $real_ensure = $logrotate::bool_absent ? {
    true  => 'absent',
    false => $ensure,
  }

  file { "logrotate_file_${name}":
    ensure  => $real_ensure,
    path    => "${logrotate::config_dir}/${name}",
    mode    => $logrotate::config_file_mode,
    owner   => $logrotate::config_file_owner,
    group   => $logrotate::config_file_group,
    require => Package['logrotate'],
    source  => $manage_file_source,
    content => $manage_file_content,
    audit   => $logrotate::manage_audit,
    noop    => $logrotate::noops,
  }

}
