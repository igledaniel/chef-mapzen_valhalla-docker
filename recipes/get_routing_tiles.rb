#
# Cookbook Name:: mapzen_valhalla-docker
# Recipe:: default
#
# Copyright 2016, Mapzen
#
# All rights reserved - Do Not Redistribute
#

stack = search('aws_opsworks_stack').first

# go get the tiles
execute 'pull tiles' do
  user  node[:valhalla][:user][:name]
  cwd   node[:valhalla][:base_dir]
  command <<-EOH
    echo -n https://s3.amazonaws.com/#{node[:valhalla][:s3bucket]}/#{node[:valhalla][:s3bucket_dir]}/ > latest_tiles.txt &&
    aws --region #{stack['region']} s3 ls s3://#{node[:valhalla][:s3bucket]}/#{node[:valhalla][:s3bucket_dir]}/ | grep -F tiles_ | awk '{print $4}' | sort | tail -n 1 >> latest_tiles.txt
  EOH
  timeout 3600
end

# open them up
execute 'extract tiles' do
  user  node[:valhalla][:user][:name]
  cwd   node[:valhalla][:base_dir]
  command <<-EOH
    rm -rf tmp_tiles old_tiles &&
    mkdir tmp_tiles &&
    curl $(cat latest_tiles.txt) 2>#{node[:valhalla][:log_dir]}/curl_tiles.log | tar xzp -C tmp_tiles 2>#{node[:valhalla][:log_dir]}/untar_tiles.log
  EOH
  retries     3
  retry_delay 60
  timeout     3600
end

# move them into place
execute 'move tiles' do
  user  node[:valhalla][:user][:name]
  cwd   node[:valhalla][:base_dir]
  command "mv #{node[:valhalla][:tile_dir]} old_tiles; mv tmp_tiles #{node[:valhalla][:tile_dir]}"
end
