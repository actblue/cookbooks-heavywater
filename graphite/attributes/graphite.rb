default[:graphite][:basedir] = "/opt/graphite"

default[:graphite][:carbon][:cache][:conf] = {
  # Specify the user to drop privileges to
  # If this is blank carbon runs as the user that invokes it
  # This user must have write access to the local data directory
  :user => "",

  # Limit the size of the cache to avoid swapping or becoming CPU bound.
  # Sorts and serving cache queries gets more expensive as the cache grows.
  # Use the value "inf" (infinity) for an unlimited cache size.
  :max_cache_size => "inf",

  # Limits the number of whisper update_many() calls per second, which effectively
  # means the number of write requests sent to the disk. This is intended to
  # prevent over-utilizing the disk and thus starving the rest of the system.
  # When the rate of required updates exceeds this, then carbon's caching will
  # take effect and increase the overall throughput accordingly.
  :max_updates_per_second => 100,

  # Softly limits the number of whisper files that get created each
  # minute.  Setting this value low (like at 50) is a good way to ensure
  # your graphite system will not be adversely impacted when a bunch of
  # new metrics are sent to it. The trade off is that it will take much
  # longer for those metrics' database files to all get created and thus
  # longer until the data becomes usable.  Setting this value high (like
  # "inf" for infinity) will cause graphite to create the files quickly
  # but at the risk of slowing I/O down considerably for a while.
  :max_creates_per_minute => "inf",

  # By default, carbon-cache will log every whisper update. This can be excessive and
  # degrade performance if logging on the same volume as the whisper data is stored.
  :log_updates => "False",


  :line_receiver_interface => "127.0.0.1",
  :line_reciever_port => 2003,

  :pickle_receiver_interface => "127.0.0.1",
  :pickle_receiver_port => 2004,

  :cache_query_interface => "127.0.0.1",
  :cache_query_port => 7002,
}




default[:graphite][:carbon][:version] = "0.9.9"
default[:graphite][:carbon][:uri] = "http://launchpadlibrarian.net/82112362/carbon-0.9.9.tar.gz"
default[:graphite][:carbon][:checksum] = "b3d42e3b93c09a82646168d7439e25cfc52143d77eba8a1f8ed45e415bb3b5cb"

default[:graphite][:whisper][:version] = "0.9.9"
default[:graphite][:whisper][:uri] = "http://launchpadlibrarian.net/82112367/whisper-0.9.9.tar.gz"
default[:graphite][:whisper][:checksum] = "66c05eafe8d86167909262dddc96c0bbfde199fa75524efa50c9ffbe9472078d"

default[:graphite][:graphite_web][:version] = "0.9.9"
default[:graphite][:graphite_web][:uri] = "http://launchpadlibrarian.net/82112308/graphite-web-0.9.9.tar.gz"
default[:graphite][:graphite_web][:checksum] = "cc78bab7fb26b341a62bbc0360d675147d77cea3075eae16c65db3b63f502419"
