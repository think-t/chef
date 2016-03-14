#
# Cookbook Name:: zabbix
# Recipe:: zabbix-repo
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when 'redhat', 'centos', 'fedora' then
  zabbix_version   = node['zabbix']['zabbix_version']
  platform_version = node['platform_version'].to_i 
  arch             = node['kernel']['machine'] == "i686" ? 'i386' : node['kernel']['machine']
  zabbix_release   = "zabbix-release-#{zabbix_version}-1.el#{platform_version}.noarch.rpm"
  zabbix_repo_url  = "http://repo.zabbix.com/zabbix/#{zabbix_version}/rhel/#{platform_version}/#{arch}/#{zabbix_release}"

  remote_file "#{cache_path}/#{zabbix_release}" do
    source zabbix_repo_url
    action :create
    not_if "rpm -q zabbix-release"
    notifies :install, 'rpm_package[zabbix-release]', :immediately
  end

  rpm_package 'zabbix-release' do
    source "#{cache_path}/#{zabbix_release}"
    only_if {File.exists?("#{cache_path}/#{zabbix_release}")}
    action :install
  end

  bash 'disabled zabbix-repo' do
    user 'root'
    code "sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/zabbix.repo"
  end
end
