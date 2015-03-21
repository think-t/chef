#
# Cookbook Name:: jdk
# Recipe:: openjdk
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
centos5_valid = [ '1.4.2', '1.6.0', '1.7.0' ]
centos6_valid = [ '1.6.0', '1.7.0', '1.8.0' ]

case node['platform']
when "centos" then
  if node['platform_version'].to_i == 5 then
    openjdk_version = centos5_valid.include?( node['jdk']['openjdk_version'] ) ? node['jdk']['openjdk_version'] : '1.6.0'
  elsif node['platform_version'].to_i == 6 then
    openjdk_version = centos6_valid.include?( node['jdk']['openjdk_version'] ) ? node['jdk']['openjdk_version'] : '1.6.0'
  end

  %W{ java-#{openjdk_version}-openjdk java-#{openjdk_version}-openjdk-devel }.each do |pkg|
    yum_package pkg do
      action :install
    end
  end

  if node['kernel']['machine'] == 'i686' then
    if openjdk_version == '1.8.0' then
      alternatives = "update-alternatives --set java /usr/lib/jvm/`rpm -q java-#{openjdk_version}-openjdk | sed -e 's/i686/i386/'`/jre/bin/java"
    else
      alternatives = "update-alternatives --set java /usr/lib/jvm/jre-#{openjdk_version}-openjdk/bin/java"
    end
  elsif node['kernel']['machine'] == 'x86_64' then
    if openjdk_version == '1.8.0' then
      alternatives = "update-alternatives --set java /usr/lib/jvm/`rpm -q java-#{openjdk_version}-openjdk`/jre/bin/java"
    else
      alternatives = "update-alternatives --set java /usr/lib/jvm/jre-#{openjdk_version}-openjdk.x86_64/bin/java"
    end
  end

  script "change java path" do
    interpreter "bash"
    user "root"
    code <<-EOH
      #{alternatives}
    EOH
  end
end
