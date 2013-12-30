class xap{

  require xap::params

  case $kernel{
    'windows' : {
      xap::windows_install{'windows-xap-install':}
    }
    default : {
      xap::linux_install{'linux-xap-install':}
    }
  }

  #copy gigaspaces-xap dir
  file { "${xap::params::gigaspaces_xap_target}" :
    source  => "puppet:///modules/${module_name}/${xap::params::gigaspaces_xap_source}",
    recurse => true,
    purge   => true,
    force   => true,
    ensure  => directory,
  } ~>

  # download gslicense.xml to client
  file { "${xap::params::license_target}":
    ensure  => present,
    content => template("${module_name}/gslicense.xml.erb"),
  } ~>

  xap::configure{'configure xap environment':}
}
