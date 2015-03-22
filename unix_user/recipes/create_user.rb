#
# Cookbook Name:: unix_user
# Recipe:: create_user
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)   
#
# All rights reserved - Do Not Redistribute
#
d_id = data_bag('users')

d_id.each do |id|
  u = data_bag_item('users', id)

  if u['id'] != 'root' then
    group u['id'] do
      gid u['gid'].to_i
      action :create
    end

    user u['id'] do
      home     u['home']
      shell    u['shell']
      uid      u['uid'].to_i
      gid      u['gid'].to_i
      password u['password']
      supports :manage_home => true, :non_unique => false
      action :create
    end

    directory "/home/#{id}/.ssh" do
      owner u['id']
      group u['id'].to_i
      mode 0700
      action :create
    end

    file "/home/#{id}/.ssh/authorized_keys" do
      owner u['id']
      group u['id']
      mode 0600
      content u['authorized_keys']
      action :create_if_missing
    end
  end
end
