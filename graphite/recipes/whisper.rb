remote_file "#{node[:graphite][:basedir]}/src/whisper-#{node.graphite.whisper.version}.tar.gz" do
  source node[:graphite][:whisper][:uri]
  checksum node[:graphite][:whisper][:checksum]
end

execute "untar whisper" do
  command "tar xzf whisper-#{node.graphite.whisper.version}.tar.gz"
  creates "#{node[:graphite][:basedir]}/src/whisper-#{node.graphite.whisper.version}"
  cwd "#{node[:graphite][:basedir]}/src"
end

execute "install whisper" do
  command "python setup.py install --prefix #{node[:graphite][:basedir]}"
  creates "#{node[:graphite][:basedir]}/lib/python#{node[:graphite][:python][:version]}/site-packages/whisper-#{node[:graphite][:whisper][:version]}-py#{node[:graphite][:python][:version]}.egg-info"
  cwd "#{node[:graphite][:basedir]}/src/whisper-#{node.graphite.whisper.version}"
end
