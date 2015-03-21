# Cookbook Name:: jobscheduler
# Recipe:: jobscheduler_client
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
if node['kernel']['machine'] == 'i686' then
  jobscheduler_bin   = "jobscheduler_linux-x86_agent.1.8.0.tar.gz"
elsif node['kernel']['machine'] == 'x86_64' then
  jobscheduler_bin   = "jobscheduler_linux-x64_agent.1.8.0.tar.gz"
end

cache_jobscheduler = "#{cache_path}/#{jobscheduler_bin}"

script "download jobscheduler agent" do
  interpreter "bash"
  user "root"
  cwd cache_path
  code <<-EOH
    wget --no-check-certificate "https://download.sos-berlin.com/JobScheduler.1.8/#{jobscheduler_bin}" -O #{jobscheduler_bin}
  EOH
  not_if { File.exists?("#{cache_path}/#{jobscheduler_bin}") }
end

template "#{cache_path}/jobscheduler_agent_config.xml" do
  owner 'root'
  group 'root'
  mode  0600
  source "jobscheduler_agent_config.xml.erb"
  action :create_if_missing
end
