class xymon {
	user { "xymon":
		ensure => present,
	}

	package { ["pcre", "pcre-devel"]:
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
		cwd     => "/tmp",
		command => "/bin/tar xvzf /tmp/xymon_latest.tar.gz --strip-components=1 --directory /tmp/xymon_latest",
		creates => "/tmp/xymon_latest",
	}
}

include xymon
