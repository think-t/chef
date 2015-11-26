#
# Cookbook Name:: vagrant_setup
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "centos" then
  if node['platform_version'].to_i == 5 then
    %w{ curl openssh-clients sudo }.each do |pkg|
      package pkg do
        action :install
        not_if "rpm -q #{pkg}"
      end
    end

    directory '/etc/sudoers.d' do
      owner  'root'
      group  'root'
      mode   '0750'
      action :create
    end

    script 'add line /etc/sudoers' do
      interpreter 'bash'
      user        'root'
      code <<-EOH
      echo '#includedir /etc/sudoers.d' >> /etc/sudoers
      EOH
    end
  end

  group 'vagrant' do
    gid    '10000'
    action :create
  end

  user 'vagrant' do
    home     '/home/vagrant'
    shell    '/bin/bash'
    uid      '10000'
    gid      '10000'
    password '$1$lHXZR03u$Gd.l0OxvyJro1VVcLeAI80'
    supports :manage_home => true, :non_unique => false
    action   :create
  end

  directory '/home/vagrant/.ssh' do
    owner  'vagrant'
    group  'vagrant'
    mode   '0700'
    action :create
  end

  remote_file '/home/vagrant/.ssh/authorized_keys' do
    source 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
    owner  'vagrant'
    group  'vagrant' 
    mode   '0600'
    action :create
  end

  template '/etc/sudoers.d/vagrant' do
    source 'sudoers_vagrant.cfg'
    owner  'root'
    group  'root'
    mode   '0440'
    action :create
  end
end
