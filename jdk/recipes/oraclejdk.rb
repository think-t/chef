#
# Cookbook Name:: jdk
# Recipe:: oraclejdk
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
if node['kernel']['machine'] == 'i686' then
  oraclejdk = 'jdk-8u40-linux-i586.rpm'
elsif node['kernel']['machine'] == 'x86_64' then
  oraclejdk = 'jdk-8u40-linux-x64.rpm'
end

script "download oracle jdk" do
  interpreter "bash"
  user "root"
  cwd cache_path
  code <<-EOH
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u40-b26/#{oraclejdk} -O #{oraclejdk}
  EOH
  not_if { File.exists?("#{cache_path}/#{oraclejdk}") }
end

rpm_package "jdk" do
  source "#{cache_path}/#{oraclejdk}"
  action :install
end

if node['kernel']['machine'] == 'i686' then
  alternatives = "update-alternatives --set java /usr/java/jdk1.8.0_40/jre/bin/java"
elsif node['kernel']['machine'] == 'x86_64' then
  alternatives = "update-alternatives --set java /usr/java/jdk1.8.0_40/jre/bin/java"
end

script "change java path" do
  interpreter "bash"
  user "root"
  code <<-EOH
    #{alternatives}
  EOH
end
