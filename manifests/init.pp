class squid(
    $acls               = $squid::params::acls,
    $http_access        = $squid::params::http_access,
    $package_name       = $squid::params::package_name,
    $proxy_port         = $squid::params::proxy_port,
    $hierarchy_stoplist = $squid::params::hierarchy_stoplist,
    $coredump_dir       = $squid::params::coredump_dir,
    $cache_dir          = $squid::params::cache_dir,
    $refresh_pattern    = $squid::params::refresh_pattern,
) inherits squid::params {


    package { 'squid':
        ensure => present,
        name   => $package_name,
    }

    group { 'squid':
        ensure  => present,
        require => Package['squid'],
        # best to let the package take care of this
    }

    file { '/etc/squid':
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        require => Package['squid'],
    }

    file { 'squid.conf':
        ensure  => present,
        path    => '/etc/squid/squid.conf',
        content => template('squid/squid.conf.erb'),
        mode    => '0640',
        owner   => 'root',
        group   => 'squid',
        require => Group['squid'],
    }

    service { 'squid':
        ensure  => running,
        enable  => true,
        require => [ Package['squid'], File['squid.conf']],
    }

}
