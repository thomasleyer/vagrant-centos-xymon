# Toplevel Makefile for Xymon
BUILDTOPDIR=`pwd`

# configure settings for Xymon
#
# Toplevel dir
XYMONTOPDIR = /usr/lib/xymon
# Server home dir for etc/, bin/
XYMONHOME = /usr/lib/xymon/server
# Server data dir for hist/ etc.
XYMONVAR = /usr/lib/xymon/data
# CGI scripts go in CGIDIR
CGIDIR = /usr/lib/xymon/cgi-bin
# Admin CGI scripts go in SECURECGIDIR
SECURECGIDIR = /usr/lib/xymon/cgi-secure
# Where to put logfiles
XYMONLOGDIR = /var/log/xymon
# Where to install manpages
MANROOT = /usr/local/man
# How to run fping or xymonping
FPING = /usr/local/sbin/fping

# Username running Xymon
XYMONUSER = xymon
# Xymon server hostname
XYMONHOSTNAME = xymond
# Xymon server IP-address
XYMONHOSTIP = 127.0.0.1
# Xymon server OS
XYMONHOSTOS = linux

# URL for Xymon webpages
XYMONHOSTURL = /xymon
# URL for Xymon CGIs
XYMONCGIURL = /xymon-cgi
# URL for Xymon Admin CGIs
SECUREXYMONCGIURL = /xymon-seccgi
# Webserver group-ID
HTTPDGID=nobody

# PCRE settings
PCRELIBS = -lpcre

# RRDtool settings
RRDDEF = -DRRDTOOL12
RRDLIBS = -lrrd 
DORRD = yes
#
# OpenSSL settings
SSLFLAGS = -DHAVE_OPENSSL -DHAVE_SSLV2_SUPPORT
SSLLIBS = -lssl -lcrypto
DOSSL = yes
#
# OpenLDAP settings
LDAPFLAGS = 
#
# clock_gettime() settings
LIBRTDEF = -lrt

# Net-SNMP settings
DOSNMP = no

# Large File Support settings
LFSDEF = -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64

include build/Makefile.Linux


# Add local CFLAGS etc. settings here

include build/Makefile.rules

