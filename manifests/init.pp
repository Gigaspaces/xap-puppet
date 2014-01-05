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
  } ~>

  xap::configure{'configure xap environment':}


}

class xap::manager inherits xap {
  # run gs-agent 
  xap::gs_agent{'xap_manager':
    name => 'lus_1_gsm_1',
    lus  => 1,
    gsm  => 1,
  }
}

class xap::container inherits xap {
  
  xap::gs_agent{'xap_container':
    name => 'gsc_1',
    gsc  => 1,
  }
}

class xap::webui inherits xap {

  xap::web_ui {"xap_webui":}
}
