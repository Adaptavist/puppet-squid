require 'spec_helper'
 
describe 'squid', :type => 'class' do
  
  package_name = 'squid'

  context "Should install package, create group, config files and run squid service with default params" do
    
    it do
      should contain_package('squid').with(
        'name' => package_name,
        'ensure' => 'present',
      )
      should contain_group('squid').with(
        'ensure' => 'present',
        'require' => 'Package[squid]', 
      )

      should contain_file('/etc/squid').with(
        'ensure'  => 'directory',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'require' => 'Package[squid]',
      )
      should contain_file('squid.conf').with(
        'path'    => '/etc/squid/squid.conf',
        'ensure'  => 'present',
        'mode'    => '0640',
        'owner'   => 'root',
        'group'   => 'squid',
        'require' => 'Group[squid]',
      ).with_content(/acl manager proto cache_object/)
      .with_content(/acl localhost src 127.0.0.1\/32 ::1/)
      .with_content(/acl to_localhost src 127.0.0.1\/32 0.0.0.0\/32 ::1/)
      .with_content(/acl localnet src 10.0.0.0\/8/)
      .with_content(/acl localnet src 172.16.0.0\/12/)
      .with_content(/acl localnet src 192.168.0.0\/16/)
      .with_content(/acl localnet src fc00::\/7/)
      .with_content(/acl localnet src fc80::\/10/)
      .with_content(/acl SSL_ports port 443/)
      .with_content(/acl Safe_ports port 80/)
      .with_content(/acl Safe_ports port 443/)
      .with_content(/acl CONNECT method CONNECT/)
      .with_content(/http_access allow manager localhost/)
      .with_content(/http_access deny manager/)
      .with_content(/http_access deny !Safe_ports/)
      .with_content(/http_access deny CONNECT !SSL_ports/)
      .with_content(/http_access allow localnet/)
      .with_content(/http_access allow localhost/)
      .with_content(/http_access deny all/)
      .with_content(/http_port 3128/)
      .with_content(/hierarchy_stoplist cgi-bin \?/)
      .with_content(/coredump_dir \/var\/sqool\/squid/)
      .with_content(/refresh_pattern \^ftp: 1440 20% 10080/)
      .with_content(/refresh_pattern \^gopher: 1440 0% 1440/)
      .with_content(/refresh_pattern . 0 20% 4320/)

      should contain_service('squid').with(
        'ensure'  => 'running',
        'enable'  => 'true',
      ).that_requires('Package[squid]')
      .that_requires('File[squid.conf]')
    end
  end

end
