class dockermod {
# Docker installation
file_line { 'debian_package':
    path => '/etc/apt/sources.list',
	#since $(lsb_release -cs) not updated for bionic, below line is hardcoded
    line => 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable',
}

exec { 'get_keys':
    command => "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
    path => ["/usr/bin", "/usr/sbin"],
	require => File_line['debian_package'],
}

exec { 'apt-get update':
    command => "/usr/bin/apt-get update",
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
	require => Exec['get_keys']
}

package { "docker-ce":
  ensure  => latest,
  require  => Exec['apt-get update'],
}
