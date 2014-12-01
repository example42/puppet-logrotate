# = Class: logrotate
#
# This is the main logrotate class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, logrotate class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $logrotate_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, logrotate main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $logrotate_source
#
# [*source_dir*]
#   If defined, the whole logrotate configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $logrotate_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $logrotate_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, logrotate main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $logrotate_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $logrotate_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $logrotate_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $logrotate_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in logrotate::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of logrotate package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include logrotate"
# - Call logrotate as a parametrized class
#
# See README for details.
#
#
class logrotate (
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $files               = params_lookup( 'files' )
  ) inherits logrotate::params {

  $config_file_mode=$logrotate::params::config_file_mode
  $config_file_owner=$logrotate::params::config_file_owner
  $config_file_group=$logrotate::params::config_file_group

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $logrotate::bool_absent ? {
    true  => 'absent',
    false => $logrotate::version,
  }

  $manage_file = $logrotate::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $logrotate::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $logrotate::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $logrotate::source ? {
    ''        => undef,
    default   => $logrotate::source,
  }

  $manage_file_content = $logrotate::template ? {
    ''        => undef,
    default   => template($logrotate::template),
  }

  ### Managed resources
  package { $logrotate::package:
    ensure  => $logrotate::manage_package,
    noop    => $logrotate::noops,
  }

  file { 'logrotate.conf':
    ensure  => $logrotate::manage_file,
    path    => $logrotate::config_file,
    mode    => $logrotate::config_file_mode,
    owner   => $logrotate::config_file_owner,
    group   => $logrotate::config_file_group,
    require => Package[$logrotate::package],
    source  => $logrotate::manage_file_source,
    content => $logrotate::manage_file_content,
    replace => $logrotate::manage_file_replace,
    audit   => $logrotate::manage_audit,
    noop    => $logrotate::noops,
  }

  ### Create instances for integration with Hiera
  if $files != {} {
    validate_hash($files)
    create_resources(logrotate::file, $files)
  }

  # The whole logrotate configuration directory can be recursively overriden
  if $logrotate::source_dir {
    file { 'logrotate.dir':
      ensure  => directory,
      path    => $logrotate::config_dir,
      require => Package[$logrotate::package],
      notify  => $logrotate::manage_service_autorestart,
      source  => $logrotate::source_dir,
      recurse => true,
      purge   => $logrotate::bool_source_dir_purge,
      force   => $logrotate::bool_source_dir_purge,
      replace => $logrotate::manage_file_replace,
      audit   => $logrotate::manage_audit,
      noop    => $logrotate::noops,
    }
  }


  ### Include custom class if $my_class is set
  if $logrotate::my_class {
    include $logrotate::my_class
  }

}
