include_recipe "monit"

package "python-twisted"

remote_file "#{node[:graphite][:basedir]}/src/carbon-#{node[:graphite][:carbon][:version]}.tar.gz" do
  source node.graphite.carbon.uri
  checksum node.graphite.carbon.checksum
end

execute "untar carbon" do
  command "tar xzf carbon-#{node[:graphite][:carbon][:version]}.tar.gz"
  creates "#{node[:graphite][:basedir]}/src/carbon-#{node[:graphite][:carbon][:version]}"
  cwd "#{node[:graphite][:basedir]}/src"
end

execute "install carbon" do
  command "python setup.py install --prefix #{node[:graphite][:basedir]}"
  creates "#{node[:graphite][:basedir]}/lib/carbon-#{node[:graphite][:carbon][:version]}-py2.6.egg-info"
  cwd "#{node[:graphite][:basedir]}/src/carbon-#{node.graphite.carbon.version}"
end

template "#{node[:graphite][:basedir]}/conf/carbon.conf" do
  mode "0644"
  variables( :line_receiver_interface => node[:graphite][:carbon][:line_receiver_interface],
             :pickle_receiver_interface => node[:graphite][:carbon][:pickle_receiver_interface],
             :cache_query_interface => node[:graphite][:carbon][:cache_query_interface] )
  notifies :restart, "service[carbon-cache]"
end

template "#{node[:graphite][:basedir]}/conf/storage-schemas.conf"

monit_fragment "carbon-cache" do
  source "carbon-cache.monitrc.erb"
end

service "carbon-cache" do
  #running true
  start_command "monit start carbon-cache"
  stop_command "monit stop carbon-cache"
  action :start
end
