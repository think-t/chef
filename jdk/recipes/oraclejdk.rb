#
# Cookbook Name:: jdk
# Recipe:: oraclejdk
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
oraclejdk_valid = [ '8u40-b26' ]

oraclejdk_build   = oraclejdk_valid.include?( node['jdk']['oraclejdk_build'] ) ? node['jdk']['oraclejdk_build'] : '8u40-b26'
oraclejdk_version = oraclejdk_build.split('-')[0]
oraclejdk_major   = oraclejdk_version.split('u')[0]
oraclejdk_minor   = oraclejdk_version.split('u')[1]
jdk_version       = "jdk1.#{oraclejdk_major}.0_#{oraclejdk_minor}"

if node['kernel']['machine'] == 'i686' then
  oraclejdk_rpm = "jdk-#{oraclejdk_version}-linux-i586.rpm"
elsif node['kernel']['machine'] == 'x86_64' then
  oraclejdk_rpm = "jdk-#{oraclejdk_version}-linux-x64.rpm"
end

download_url = "http://download.oracle.com/otn-pub/java/jdk/#{oraclejdk_build}/#{oraclejdk_rpm}"

script "download oracle jdk" do
  interpreter "bash"
  user "root"
  cwd cache_path
  code <<-EOH
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" #{download_url} -O #{oraclejdk_rpm}
  EOH
  not_if { File.exists?("#{cache_path}/#{oraclejdk_rpm}") }
end

rpm_package "jdk" do
  source "#{cache_path}/#{oraclejdk_rpm}"
  action :install
end

script "change java path" do
  interpreter "bash"
  user "root"
  code <<-EOH
    update-alternatives --set java /usr/java/#{jdk_version}/jre/bin/java
  EOH
end
