class squid::params {

    $package_name = $::operatingsystem ? {
        default => 'squid',
    }

    # Squid normally listens to port 3128
    $proxy_port = 3128

    $acls = [
        ['manager', 'proto', 'cache_object', ],
        ['localhost', 'src', '127.0.0.1/32', '::1',],
        ['to_localhost', 'src', '127.0.0.1/32', '0.0.0.0/32', '::1',],

        [], # put blank line in config file

        # Example rule allowing access from your local networks.
        # Adapt to list your (internal) IP networks from where browsing
        # should be allowed
        ['localnet', 'src', '10.0.0.0/8',],         # RFC1918 possible internal network
        ['localnet', 'src', '172.16.0.0/12',],  # RFC1918 possible internal network
        ['localnet', 'src', '192.168.0.0/16',], # RFC1918 possible internal network
        ['localnet', 'src', 'fc00::/7',],           # RFC 4193 local private network range
        ['localnet', 'src', 'fc80::/10',],          # RFC 4291 link-local (directly plugged) machines

        [], # put blank line in config file

        ['SSL_ports', 'port', '443',],
        ['Safe_ports', 'port', '80',],                      # http
        # ['Safe_ports', 'port', '21',],                    # ftp
        ['Safe_ports', 'port', '443',],                     # https
        # ['Safe_ports', 'port', '70',],                    # gopher
        # ['Safe_ports', 'port', '210',],               # wais
        # ['Safe_ports', 'port', '1025-65535',],    # unregistered ports
        # ['Safe_ports', 'port', '280',],               # http-mgmt
        # ['Safe_ports', 'port', '488',],               # gss-http
        # ['Safe_ports', 'port', '591',],               # filemaker
        # ['Safe_ports', 'port', '777',],               # multiling http

        ['CONNECT', 'method', 'CONNECT',],

    ]

    $http_access = [
        # Only allow cachemgr access from localhost
        [ 'allow', 'manager', 'localhost',],
        [ 'deny', 'manager',],

        # Deny requests to certain unsafe ports
        [ 'deny', '!Safe_ports'],

        # Deny CONNECT to non SSL ports
        [ 'deny', 'CONNECT', '!SSL_ports',],

        # Enable to protect innocent web applications
        # running on the proxy server who think the only
        # one who can access services on "localhost"
        # is a local user
        # [ 'deny', 'to_localhost', ],

        # INSERT YOUR OWN RULES HERE

        # Example rule allowing access from your local networks.
        # Adapt localnet in the ACL section to list your (internal) IP networks
        # from where browsing should be allowed
        [ 'allow', 'localnet', ],
        [ 'allow', 'localhost', ],

        # And finally deny all other access to this proxy
        [ 'deny', 'all',]

    ]

    # We recommend you to use at least the following line.
    $hierarchy_stoplist = [ 'cgi-bin', '?',]

    # Uncomment and adjust the following to add a disk cache directory
    #$cache_dir = [ 'ufs' '/var/spool/squid', '100', '16', '256',]

    $coredump_dir = '/var/sqool/squid'

    $refresh_pattern = [
        # Add your own refresh patterns above these
        ['^ftp:', '1440', '20%', '10080',],
        ['^gopher:', '1440', '0%', '1440',],
        ['-i', '(/cgi-bin/|\?)', '0', '0%', '0',],
        ['.', '0', '20%', '4320',],
    ]
}
