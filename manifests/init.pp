class tom8 {
#  package { 'redhat-lsb.x86_64': ensure => present, }

  file { '/usr/tomcat8':
    ensure  => directory,
    owner   => 'webuser',
    group   => 'webuser',
    recurse => true,
    require => Class['base'],
  }

  file { '/root/apache-tomcat-8.0.32.tar.gz':
    owner  => 'root',
    group  => 'root',
    ensure => 'present',
    source => 'puppet:///modules/tom8/tomcat8.tar.gz',
    notify => Exec['untartomcat8'],
  }

  exec { 'untartomcat8':
    command     => '/bin/tar -C / -xvzf /root/apache-tomcat-8.0.32.tar.gz',
    cwd         => '/root/',
    refreshonly => true,
    require     => File['/root/apache-tomcat-8.0.32.tar.gz'],
    notify      => File['/usr/tomcat8'],
  }

  file { '/usr/tomcat8/webapps':
    ensure  => directory,
    owner   => 'webuser',
    group   => 'webuser',
    mode    => 0774,
    require => Class['base']
  }

  file { '/var/log/tomcat8':
    ensure  => directory,
    owner   => 'webuser',
    group   => 'webuser',
    mode    => 0774,
    require => Class['base']
  }

  file { '/usr/sbin/dtomcat8':
    content => template('tom8/dtomcat8.erb'),
    owner   => root,
    group   => root,
    mode    => 755,
  }

  file { '/etc/init.d/tomcat8':
    content => template('tom8/tomcat8_init.erb'),
    owner   => root,
    group   => root,
    mode    => 755,
  }

}
