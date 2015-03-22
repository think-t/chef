#
# Cookbook Name:: unix_user
# Recipe:: grant_sudo
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)   
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "centos" then
  if node['platform_version'].to_i == 5 then
    script "modify sudoers" do
      interpreter "bash"
      user "root"
      code <<-EOH
        sed -i '/^#includedir\ \/etc\/sudoers.d/d' /etc/sudoers
      EOH
      not_if "grep "#includedir /etc/sudoers.d" /etc/sudoers"
    end
    
    directory "/etc/sudoers.d" do
      owner "root"
      group "root"
      mode  0750
      action :create
    end
  end
end

d_id = data_bag('users')

d_id.each do |id|
  u = data_bag_item('users', id)

  file "/etc/sudoers.d/#{id}" do
    owner "root"
    group "root"
    mode  0440
    content u['sudo']
    action :create_if_missing
  end
end
