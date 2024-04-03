#  automate the task of creating a custom HTTP header response, but with Puppet.
#update apt package
exec { 'update_apt_store':
  command => '/usr/bin/apt-get update',
}
#Install nginx package
package { 'nginx':
  ensure  => 'present',
  require => Exec['update_apt_store'],
}
# Add a line to Nginx configuration
file_line { 'http_header':
  path    => '/etc/nginx/nginx.conf',
  line    => "http {\n\tadd_header X-Served-By \"${hostname}\";",
  match   => 'http {',
  require => Package ['nginx'],
}
#Restart nginx
exec { 'restart_nginx':
  command => '/usr/sbin/service nginx restart',
  require => File_line ['http_header']
}
