include_recipe "apache2::mod_python"

package "python-cairo-dev"
package "python-django"
package "python-memcache"
package "python-rrdtool"
package "python-django-tagging"

remote_file "#{node[:graphite][:basedir]}/src/graphite-web-#{node[:graphite][:graphite_web][:version]}.tar.gz" do
  source node[:graphite][:graphite_web][:uri]
  checksum node[:graphite][:graphite_web][:checksum]
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{node[:graphite][:graphite_web][:version]}.tar.gz"
  creates "#{node[:graphite][:basedir]}/src/graphite-web-#{node[:graphite][:graphite_web][:version]}"
  cwd "#{node[:graphite][:basedir]}/src"
end

remote_file "#{node[:graphite][:basedir]}/src/graphite-web-#{node[:graphite][:graphite_web][:version]}/webapp/graphite/storage.py.patch" do
  source "http://launchpadlibrarian.net/65094495/storage.py.patch"
  checksum "8bf57821"
end

execute "install graphite-web" do
  command "python setup.py install --prefix #{node[:graphite][:basedir]}"
  creates "#{node[:graphite][:basedir]}/webapp/graphite_web-#{node.graphite.graphite_web.version}-py2.6.egg-info"
  cwd "#{node[:graphite][:basedir]}/src/graphite-web-#{node.graphite.graphite_web.version}"
end

template "#{node[:apache][:dir]}/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
  notifies :restart, resources(:service => "apache2"), :delayed
end
apache_site "graphite"

["default", "default-ssl", "000-default"].each do |site|
  apache_site site do
    enable false
  end
end

# Give the web app write permission to places
[ "#{node[:graphite][:basedir]}/storage/log/webapp",
  "#{node[:graphite][:basedir]}/storage"].each do |dir|
  directory dir do
    owner node[:apache][:user]
    #group "www-data"
  end
end

execute "create graphite.db" do
  command "python #{node[:graphite][:basedir]}/webapp/graphite/manage.py syncdb --noinput"
  user node[:apache][:user]
  creates "#{node[:graphite][:basedir]}/storage/graphite.db"
  notifies :restart, resources(:service => "apache2"), :delayed
end
