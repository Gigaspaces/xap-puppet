# base role to be extended
class xap{

  require xap::params
  # install JDK  regards OS
  case $kernel{
    'windows' : {
      xap::windows_install{'windows-xap-install':}
    }
    default : {
      xap::linux_install{'linux-xap-install':}
    }
  }

  #copy gigaspaces-xap dir to the target xap installation directoary
  file { "${xap::params::gigaspaces_xap_target}" :
    source  => "puppet:///modules/${module_name}/${xap::params::gigaspaces_xap_source}",
    recurse => true,
    ensure  => directory,
  } ~>
  #configure installation
  xap::configure{'configure xap environment':}


}
# manager role
class xap::manager  (
  $global_lus = 0,
  $lus        = 1,
  $global_gsm = 0,
  $gsm        = 1,
  $gsc        = 2,
) inherits xap {
  # run gs-agent
  xap::gs_agent{'xap_manager':
    name  => "manager_gsa_global_lus_${global_lus}_gsa_lus_${lus}_gsa_global_gsm_${global_gsm}_gsa_gsm_${gsm}_gsa_gsc_${gsc}",
    g_lus => $global_lus,
    l_lus => $lus,
    g_gsm => $global_gsm,
    l_gsm => $gsm,
    l_gsc => $gsc,
  }
}
# constainer role
class xap::container (
  $global_lus = 0,
  $lus        = 0,
  $global_gsm = 0,
  $gsm        = 0,
  $gsc        = 4,
)inherits xap {

  xap::gs_agent{'xap_container':
    name =>  "container_gsa_global_lus_${global_lus}_gsa_lus_${lus}_gsa_global_gsm_${global_gsm}_gsa_gsm_${gsm}_gsa_gsc_${gsc}",
    l_gsc  => $gsc,
  }
}
# web-ui role
class xap::webui inherits xap {

  xap::web_ui {"xap_webui":}
}
