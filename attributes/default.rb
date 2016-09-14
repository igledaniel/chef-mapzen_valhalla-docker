default[:valhalla][:user][:name]    = 'valhalla'
default[:valhalla][:base_dir]       = '/data'
default[:valhalla][:s3bucket]       = 'mapzen.valhalla'
default[:valhalla][:s3bucket_dir]   = 'prod'
default[:valhalla][:log_dir]        = "#{node[:valhalla][:base_dir]}/logs"
default[:valhalla][:tile_dir]       = "#{node[:valhalla][:base_dir]}/valhalla"
default[:valhalla][:transit_dir]    = "#{node[:valhalla][:base_dir]}/valhalla/transit"
default[:valhalla][:elevation_dir]  = "#{node[:valhalla][:base_dir]}/valhalla/elevation"
