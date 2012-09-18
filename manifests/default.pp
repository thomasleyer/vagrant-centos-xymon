class xymon {
	user { "xymon":
		ensure => present,
	}

	package { ["pcre", "pcre-devel","httpd"]:
		ensure => installed,
	}

	exec { "wget XYMON":
		cwd     => "/tmp/",
		command => "/usr/bin/wget http://sourceforge.net/projects/xymon/files/latest/download?source=files -O xymon_latest.tar.gz",
		creates => "/tmp/xymon_latest.tar.gz",
	}

	file { "/tmp/xymon_latest":
		ensure => directory,
	}

	exec { "untar XYMON":
		cwd        => "/tmp/xymon_latest",
		command    => "/bin/tar xvzf /tmp/xymon_latest.tar.gz --strip-components=1 --directory /tmp/xymon_latest",
		creates    => "/tmp/xymon_latest/configure.server",
		logoutput  => true,
	}

	exec { "XYMON configure.server":
		cwd			    => "/tmp/xymon_latest",
		command     => "/tmp/xymon_latest/configure.server --prefix=/tmp/xymon",
		environment => ['USEXYMONPING=yes','ENABLESSL=y'],
		require     => Exec["untar XYMON"],
		creates     => "/tmp/xymon_latest/Makefile",
		logoutput   => true,
	}

	exec { "XYMON make":
		cwd         => "/tmp/xymon_latest",
    command     => "/usr/bin/make",
    require     => Exec["XYMON configure.server"],
		creates     => "/tmp/xymon_latest/xymond/xymond", 
    logoutput   => true,
		timeout     => 0,
  }

	exec { "XYMON make install":
		cwd         => "/tmp/xymon_latest",
    command     => "/usr/bin/make install",
    require     => Exec["XYMON make"],
		creates     => "/tmp/xymon",
    logoutput   => true,
  }

}

include xymon
