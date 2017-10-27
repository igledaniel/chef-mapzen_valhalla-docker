#
# Cookbook Name:: mapzen_valhalla-docker
# Recipe:: default
#
# Copyright 2016, Mapzen
#
# All rights reserved - Do Not Redistribute
#

# make the valhalla user
user node[:valhalla][:user][:name] do
  uid         node[:valhalla][:user][:uid]
  gid         node[:valhalla][:user][:gid]
  manage_home false
  home        node[:valhalla][:base_dir]
  not_if      { node[:valhalla][:user][:name] == 'root' }
end

# set up directory structure
dirs = [
  node[:valhalla][:base_dir],
  node[:valhalla][:log_dir],
  node[:valhalla][:tile_dir],
  node[:valhalla][:transit_dir],
  node[:valhalla][:elevation_dir]
]

dirs.each do |d|
  directory d do
    owner node[:valhalla][:user][:name]
    recursive true
  end
end

include_recipe 'mapzen_valhalla-docker::get_routing_tiles'
