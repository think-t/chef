#
# Cookbook Name:: jobscheduler
# Recipe:: default
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
if node['jobscheduler']['mode'] == 'server' then
  include_recipe "jobscheduler::jobscheduler_server"
elsif node['jobscheduler']['mode'] == 'client' then
  include_recipe "jobscheduler::jobscheduler_client"
end
