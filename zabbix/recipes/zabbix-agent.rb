#
# Cookbook Name:: zabbix
# Recipe:: zabbix-agent
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when 'redhat', 'centos', 'fedora' then
  yum_package 'zabbix-agent' do
    options "--enablerepo=zabbix"
    action :install
    not_if "rpm -q zabbix-agent"
  end 

  service 'zabbix-agent' do
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end

  template '/etc/zabbix/zabbix_agentd.conf' do
    source "zabbix_zabbix_agentd.conf.erb"
    owner  "root"
    group  "root"
    mode   0644
    action :create
    variables({
      :server        => node['zabbix']['server'],
      :server_active => node['zabbix']['server_active'],
      :hostname      => node['zabbix']['hostname']
    })
    notifies :restart, 'service[zabbix-agent]'
  end
end
