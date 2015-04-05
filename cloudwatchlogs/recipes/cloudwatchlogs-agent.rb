#
# Cookbook Name:: cloudwatchlogs
# Recipe:: cloudwatchlogs-agent
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
awslogs_agent_setup = 'awslogs-agent-setup.py'
download_url        = "https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/#{awslogs_agent_setup}" 
awslogs_conf        = node['cloudwatchlogs']['awslogs_conf']
awscli_conf         = node['cloudwatchlogs']['awscli_conf']
region              = node['cloudwatchlogs']['region']

case node['platform']
  when 'amazon' then
  yum_package 'awslogs' do
    action :install
    not_if "rpm -q awslogs"
  end 

  when 'redhat', 'centos', 'fedora' then
  yum_package 'wget' do
    action :install
    not_if "rpm -q wget"
  end

  template "#{cache_path}/awslogs.conf" do
    source "cloudwatchlogs_awslogs.conf.erb"
    owner  "root"
    group  "root"
    mode   0644
    action :create
  end

  script "download awslogs setup script" do
    interpreter "bash"
    user "root"
    cwd cache_path
    code <<-EOH
      wget #{download_url}
    EOH
    not_if { File.exists?("#{cache_path}/#{awslogs_agent_setup}") }
  end

  script "setup awslogs" do
    interpreter "bash"
    user "root"
    cwd cache_path
    code <<-EOH
      python #{cache_path}/#{awslogs_agent_setup} -n --region #{region} --configfile "#{cache_path}/awslogs.conf" 
    EOH
  end
end

service 'awslogs' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template awslogs_conf do
  source "cloudwatchlogs_awslogs.conf.erb"
  owner  "root"
  group  "root"
  mode   0644
  action :create
  notifies :restart, 'service[awslogs]'
end

template awscli_conf do
  source "cloudwatchlogs_awscli.conf.erb"
  owner  "root"
  group  "root"
  mode   0600
  action :create
  variables({
    :region => region,
  })
  notifies :restart, 'service[awslogs]'
end
