class adr::r (
  $r_version = '>=3.2.0',
  $comment = 'This is the apt repository for R - the language for statistical computing',
  $location = 'http://cran.rstudio.com/bin/linux/ubuntu/',
  $release = 'trusty/',
  $repos = '',
  $key_id = 'E084DAB9',
  $key_server = 'keyserver.ubuntu.com',
) {
  
  include apt
  
  apt::source { 'R':
    comment  => $comment,
    location => $location,
    release  => $release,
    repos    => $repos,
    key      => {
      id     => $key_id,
      server => $key_server,
    }
  }
  
  exec { 'apt-get-update':
    command => '/usr/bin/apt-get update',
  }
  
  package {'r-base':
    require => Apt::Source['R'],
    ensure  => installed,
    notify  => Exec['apt-get-update']
  }
  
  package {'littler':
    ensure => latest,
  }
  
  package {'libmysqlclient-dev':
    ensure => latest,
  }
  
  adr::package{'forecast': dependencies => true}
  adr::package{'dplyr': dependencies => true}
  adr::package{'RMySQL': dependencies => true}
  
}