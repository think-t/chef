#
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
include_recipe "zabbix::zabbix-repo"
include_recipe "zabbix::zabbix-agent"
