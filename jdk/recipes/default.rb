#
# Cookbook Name:: jdk
# Recipe:: default
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
if node['jdk']['enable_oraclejdk'] then
  include_recipe "jdk::oraclejdk"
else
  include_recipe "jdk::openjdk"
end
