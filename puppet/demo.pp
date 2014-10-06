Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }


stage { 'preinstall':
  before => Stage['main']
}
 
class apt_get_update {
  exec { 'apt-get -y update': }
}
 
class { 'apt_get_update':
  stage => preinstall
}

import "classes/*"

node default {
	include springboot
	include consulclient

	#
	# Configure Service with Consul (including health check)
	#

	consul::service { 'demo':
		tags => ['actuator'],
		port => 8080,
		check_script => '/opt/health.py',
		check_interval => '5s',
	}

	file { '/opt/health.py':
		path         => '/opt/health.py',
		ensure       => present,
		mode         => 0755,
		source       => '/vagrant/demo/health.py',
		before       => Consul::Service['demo']
	}

}
