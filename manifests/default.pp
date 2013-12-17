class xymon {

###
### based on http://www.xymon.com/xymon/help/install.html#commonrhel6
###

	user { "xymon":
		ensure => present,
	}
	user { "puppet":
		ensure => present,
	}
	group { "puppet":
		ensure => present,
	}

	package { "firefox":
		ensure => installed,
	}

	package { ["pcre", "pcre-devel","httpd", "gcc", "make", "openssl-devel", "openldap-devel", "rrdtool-devel"]:
		ensure => installed,
	}

  exec { "wget fping":
    cwd     => "/tmp/",
    command => "/usr/bin/wget http://fping.org/dist/fping-3.2.tar.gz -O fping-3.2.tar.gz",
    creates => "/tmp/fping-3.2.tar.gz",
  }
	exec { "untar/gz fping":
		cwd => "/tmp",
		command => "/bin/tar zxf fping-3.2.tar.gz",
		creates => "/tmp/fping-3.2",
		require => Exec["wget fping"],
	}
	exec { "configure fping":
		cwd => "/tmp/fping-3.2",
		command => "/tmp/fping-3.2/configure",
		require => [ Exec["untar/gz fping"], Package ["pcre", "pcre-devel","httpd", "gcc", "make", "openssl-devel", "openldap-devel", "rrdtool-devel"] ],
		creates => "/tmp/fping-3.2/Makefile",
	}

	exec { "make and make install fping":
		cwd => "/tmp/fping-3.2",
		command => "/usr/bin/make && /usr/bin/make install",
		require => Exec["configure fping"],
		creates => "/tmp/fping-3.2/src/fping",
	}


	exec { "wget XYMON":
		cwd     => "/tmp/",
		command => "/usr/bin/wget http://sourceforge.net/projects/xymon/files/latest/download?source=files -O xymon_latest.tar.gz",
		creates => "/tmp/xymon_latest.tar.gz",
		require => Exec["make and make install fping"],
	}

	file { "/tmp/xymon_latest":
		ensure => directory,
	}

	exec { "untar XYMON":
		cwd        => "/tmp/xymon_latest",
		command    => "/bin/tar xvzf /tmp/xymon_latest.tar.gz --strip-components=1 --directory /tmp/xymon_latest",
		creates    => "/tmp/xymon_latest/configure.server",
		require    => Exec["wget XYMON"],
		logoutput  => true,
	}

#	exec { "XYMON configure.server":
#		cwd			    => "/tmp/xymon_latest",
#		command     => "/tmp/xymon_latest/configure.server --prefix=/usr/lib/xymon/",
#		environment => ['USEXYMONPING=yes','ENABLESSL=y'],
#		require     => Exec["untar XYMON"],
#		creates     => "/tmp/xymon_latest/Makefile",
#		logoutput   => true,
#	}

	file { "/tmp/xymon_latest/Makefile":
		ensure => file,
		source => "/tmp/vagrant-puppet/manifests/Makefile",
		require => Exec["wget XYMON"],
	}

	exec { "XYMON make":
		cwd         => "/tmp/xymon_latest",
    command     => "/usr/bin/make",
    require     => File["/tmp/xymon_latest/Makefile"],
		creates     => "/tmp/xymon_latest/xymond/xymond", 
    logoutput   => true,
		timeout     => 0,
  }

	exec { "XYMON make install":
		cwd         => "/tmp/xymon_latest",
    command     => "/usr/bin/make install",
    require     => Exec["XYMON make"],
		creates     => "/usr/lib/xymon/server/xymon.sh",
    logoutput   => true,
  }

	file { "/etc/init.d/xymon":
		ensure  => file,
		mode    => '0750',
		source  => '/tmp/xymon_latest/rpm/xymon-init.d',
		require => Exec["XYMON make install"], 
  }

	exec { "/sbin/chkconfig --add xymon; touch /xymon_service_enabled":
		cwd => "/",
		require => File["/etc/init.d/xymon"],
		creates => "/xymon_service_enabled",
	}

	service { "xymon":
		ensure => running,
		enable => true,
		require => Exec["/sbin/chkconfig --add xymon; touch /xymon_service_enabled"],
	}

	file { "/etc/httpd/conf.d/xymon-apache.conf":
		ensure => link,
		target => '/usr/lib/xymon/server/etc/xymon-apache.conf',
		require => Exec["XYMON make install"],
	}
  service { "httpd":
		ensure => running,
		enable => true,
		require => File["/etc/httpd/conf.d/xymon-apache.conf"],
	}

}

include xymon
