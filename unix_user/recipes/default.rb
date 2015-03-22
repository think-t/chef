#
# Cookbook Name:: unix_user
# Recipe:: default
#
# Copyright 2015, think-t(http://think-t.hatenablog.com)
#
# All rights reserved - Do Not Redistribute
#
include_recipe "unix_user::create_user"
include_recipe "unix_user::grant_sudo"
