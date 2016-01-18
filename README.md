# Squid Module
[![Build Status](https://travis-ci.org/Adaptavist/puppet-squid.svg?branch=master)](https://travis-ci.org/Adaptavist/puppet-squid)

The **Squid** module handles the installation, running and configuration of 
the [squid](#squid) http proxy server.

## Usage

Bind to a specific interface:

You can use the `squid_proxy_port` parameter in Hiera to configure a specific interface to bind to by adding the ip address of the interface before the port. e.g.

	squid_proxy_port : '192.168.100.1:3128'

URL whitelists can be created by using `squid::acls` and `squid::http_access` hiera keys. e.g.

	squid::acls :
		- ['whitelist', 'dstdomain', '/etc/squid/whitelist.txt',]

	squid::http_access :
		- ['allow', 'whitelist',]
		- ['deny', 'all',]


## Configuration

Here we give a list of available configuration parameters:

`squid::package_name` is the name of the OS package for squid, this shouldn't need changing. The default value is 'squid'.

`squid::proxy_port` is the name of the port that squid will receive connections from clients. The default value is 3128.

`squid::acls` an array of arrays where each sub array is an `acl` directive in the squid.conf configuration file. 

For example: 

	squid::acls : 
		- ['localnet', 'src', '10.0.0.0/8'] 		# RFC1918 possible internal network
		- ['localnet', 'src', '172.16.0.0/12'] 	# RFC1918 possible internal network
		- ['localnet', 'src', '192.168.0.0/16'] # RFC1918 possible internal network
		- ['localnet', 'src', 'fc00::/7'] 			# RFC 4193 local private network range
		- ['localnet', 'src', 'fc80::/10'] 			# RFC 4291 link-local (directly plugged) machines

`squid::http_access` an array of arrays where each sub array is an `http_access` directive in the squid.conf configuration file. 

For example:

	squid::http_access :
			- [ 'allow', 'localnet' ]
			- [ 'allow', 'localhost' ] 
			- [ 'deny', 'all']

`squid::hierarchy_stoplist` is a one-dimensional array for the `hierarchy_stoplist` line in the squid.conf configuration file.

	squid::hierarchy_stoplist : [ 'cgi-bin', '?']

`squid::cache_dir` is a one-dimensional array for the `hierarchy_stoplist` line in the squid.conf configuration file. This is optional.

	squid::cache_dir : [ 'ufs' '/var/spool/squid', '100', '16', '256']

`squid::coredump_dir` is string indicating the path to where core dump files are placed.

	squid::coredump_dir : '/var/sqool/squid'

`squid::refresh_pattern` is an array of arrays where each sub array is a refresh_pattern directive in the squid.conf configuration file.

	squid::refresh_pattern : 
			- ['^ftp:', '1440', '20%', '10080']
			- ['^gopher:', '1440', '0%', '1440']
			- ['-i', '(/cgi-bin/|\?)', '0', '0%', '0']
			- ['.', '0', '20%', '4320']

## Dependencies

This module depends on the following modules:

## Caveats

No caveats.

## References

* [**Squid**](id:squid) http://www.squid-cache.org/


