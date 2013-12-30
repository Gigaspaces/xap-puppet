class xap::params {

  $jdk_version = '7'
  $jdk_update ='45'
  $jdk_home = "jdk1.${jdk_version}.0_${jdk_update}"
  $jdk_arch = $hardwaremodel ? {
    'i686'   => 'i586',
    default => 'x64',
  }

  $jdk_name="jdk-${jdk_version}u${jdk_update}-${kernel}-${jdk_arch}"

  $jdk_file = $kernel ? {
    'windows' => "${jdk_name}.exe",
    default   => "${jdk_name}.tar.gz",
  }

  # XAP Installation parameters
  $gigaspaces_xap_source = 'gigaspaces-xap-premium-9.6.2-ga'

  $gigaspaces_xap_target = $kernel ? {
    'windows' => "c:/${gigaspaces_xap_source}",
    default   => "/opt/${gigaspaces_xap_source}",
  }

  # license configuration
  $license_target = "${gigaspaces_xap_target}/gslicense.xml"
  $license_key = 'Mar 21, 2014~shady$gigaspaces.com@cSdVRnPNQQSIRQRQYWFO#EVALUATION^9.0XAPPremium%UNBOUND+UNLIMITED//WAN//EMT'

  #configure environment
  $extension = $kernel ? {
    'windows' => 'bat',
    default   => 'sh',
  }

  $config_dir = $kernel ? {
    'windows' => 'c:/gigaspaces',
    default   => '/opt/gigaspaces',
  }

  #LOOKUPLOCATORS value
  $lookup_locators = ''

  # LOOKUPGROUPS value
  $lookup_groups ="gigaspaces-9.6.2-XAPPremium-ga"

  # JAVA_VM_NAME value
  $java_vm_name = $kernel ? {
    default => 'ALL',
  }

  # JAVA_HOME value
  $java_home = $kernel ? {
    'windows' => "C:/Programs file/java/${jdk_home}",
    default => "/usr/java/${jdk_home}",
  }

  # configure System properties
  $com_gigaspaces_logger_RollingFileHandler_filename_pattern=''
  $com_gs_deploy=''
  $com_gs_work=''
  $com_gigaspaces_lib_platform_ext=''
  $com_gs_pu_common=''
  $com_gigaspaces_grid_gsa_config_directory=''
  $java_util_logging_config_file=''
  $com_gs_transport_protocol_lrmi_bind_port=''
  $com_gs_transport_protocol_lrmi_max_conn_pool=''
  $com_gs_transport_protocol_lrmi_max_threads=512
  $com_sun_jini_reggie_initialUnicastDiscoveryPort=''
  $com_gs_zones=''
  $com_gs_grid_secured=false

  # JAVA_OPTION
  $Xloggc = "${config_dir}/log/gc.log"

  # GSC_JAVA_OPTIONS
  $Xms = '300m'
  $Xmx ='8g'
  $Xmn =''
  $XXCMSInitiatingOccupancyFraction = '60'
}
