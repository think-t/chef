#
# Cookbook Name:: jdk
# Recipe:: openjdk
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
%w{ openjdk, openjdk-devel }.each do |pkg|
  yum_package pkg do
    action :install
  end
  not_if "rpm -q #{pkg}"
end
