#
# Cookbook Name:: jdk
# Recipe:: default
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
p "use_oracle_jdk: " + node['jdk']['use_oracle_jdk']
if node['jdk']['use_oracle_jdk'] == true then
p "true"
  include_recipe "jdk::oraclejdk"
else
p "false"
  include_recipe "jdk::openjdk"
end
