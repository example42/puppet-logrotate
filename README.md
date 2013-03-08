# Puppet module: logrotate

This is a Puppet module for logrotate
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-logrotate

The logrotate::rule define has been adapted from:

https://github.com/rodjek/puppet-logrotate/blob/master/templates/etc/logrotate.d/rule.erb

Released with this licence: https://github.com/rodjek/puppet-logrotate/blob/master/LICENSE


The logrotate::conf define has been adapted from:

https://github.com/arioch/puppet-logrotate/blob/master/manifests/file.pp

Released with this license: https://github.com/arioch/puppet-logrotate/blob/master/LICENSE

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Module specific 

This module provides different options on how to manage logrotate configuration files.

You can configure the main configuration file with the source or template parameters

You can configure the single logrotate configuration snippets in several ways:

* You can populate the whole logrotate.d with the source_dir parameter

* You can create a single configuration snippet with these alternative defines:

  * logrotate::rule - Create snippets based of a lot parameters for each option

  * logrotate::conf - Create snippets based of a configurable template and the provided options

  * logrotate::file - Provide directly a custom file from the source you want

Refer to the documentation in the single defines for details on the option's usage.

All the methods are alternative but can cohexist, it's up to you to use the alternative that better fits your needs.


## USAGE - Basic management

* Install logrotate with default settings

        class { 'logrotate': }

* Install a specific version of logrotate package

        class { 'logrotate':
          version => '1.0.1',
        }

* Remove logrotate resources (it automatically removes also the files provided by the logrotate::rule logrotate::conf and logrotate::file defines

        class { 'logrotate':
          absent => true
        }

* Enable auditing without without making changes on existing logrotate configuration *files*

        class { 'logrotate':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module. It applies also to logrotate::rule logrotate::conf and logrotate::file defines

        class { 'logrotate':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'logrotate':
          source => [ "puppet:///modules/example42/logrotate/logrotate.conf-${hostname}" , "puppet:///modules/example42/logrotate/logrotate.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'logrotate':
          source_dir       => 'puppet:///modules/example42/logrotate/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'logrotate':
          template => 'example42/logrotate/logrotate.conf.erb',
        }

* Automatically include a custom subclass

        class { 'logrotate':
          my_class => 'example42::my_logrotate',
        }



[![Build Status](https://travis-ci.org/example42/puppet-logrotate.png?branch=master)](https://travis-ci.org/example42/puppet-logrotate)
