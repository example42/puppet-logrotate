# Class: logrotate::params
#
# This class defines default parameters used by the main module class logrotate
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to logrotate class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class logrotate::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'logrotate',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/logrotate.d',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/logrotate.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = undef
  $files = {}

}
