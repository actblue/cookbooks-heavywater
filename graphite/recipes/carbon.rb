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
  notifies :restart, "service[carbon-cache]"
end

template "#{node[:graphite][:basedir]}/conf/storage-schemas.conf"
template "#{node[:graphite][:basedir]}/conf/storage-aggregation.conf"

monit_fragment "carbon-cache" do
  source "carbon-cache.monitrc.erb"
end

service "carbon-cache" do
  #running true
  start_command "monit start carbon-cache"
  stop_command "monit stop carbon-cache"
  action :start
end

# Nuke carbon logs that need nuking
template "/usr/local/sbin/carbon-log-cleaner.sh" do
  source "carbon-log-cleaner.sh.erb"
  mode "0755"
end
cron "carbon log cleaner" do
  command "/usr/local/sbin/carbon-log-cleaner.sh"
  minute 15
  hour 4
  user "root"
end
