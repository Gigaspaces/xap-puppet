class xap::params {

  $jdk_version = '7' # jdk version
  $jdk_update ='45'  # jdk update
  $jdk_home = "jdk1.${jdk_version}.0_${jdk_update}" # jdk home
  $jdk_arch = $hardwaremodel ? { # node 32bit or 64bit
    'i686'   => 'i586',
    default => 'x64',
  }

  $jdk_name="jdk-${jdk_version}u${jdk_update}-${kernel}-${jdk_arch}" # jdk file name

  $jdk_file = $kernel ? { # jdk file name with extension
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

  $gs_webui_war_file = "gs-webui-9.6.2-9900-RELEASE.war"

  #LOOKUPLOCATORS value
  $lookup_locators = '192.168.141.130'

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

  # configure firewall\
  $com_sun_jini_reggie_initialUnicastDiscoveryPort=4174
  $com_gs_transport_protocol_lrmi_bind_port_start=8000
  $com_gs_transport_protocol_lrmi_bind_port_end=8100
  $com_gigaspaces_system_registryPort=10098
  $com_gigaspaces_start_httpPort=9813
  $com_gs_webui_port=8099

  # configure System properties
  $com_gigaspaces_logger_RollingFileHandler_filename_pattern="${config_dir}/logs/"
  $com_gs_deploy="${config_dir}/deploy"
  $com_gs_work="${config_dir}/work"
  $com_gigaspaces_lib_platform_ext="${gigaspaces_xap_target}/lib/platform/ext"
  $com_gs_pu_common="${gigaspaces_xap_target}/lib/optional/pu-common"
  $com_gigaspaces_grid_gsa_config_directory="${gigaspaces_xap_target}/config/gsa"
  $java_util_logging_config_file="${gigaspaces_xap_target}/config/gs_logging.properties"
  $com_gs_transport_protocol_lrmi_bind_port="${com_gs_transport_protocol_lrmi_bind_port_start}-${com_gs_transport_protocol_lrmi_bind_port_end}"
  $com_gs_transport_protocol_lrmi_max_conn_pool=1024
  $com_gs_transport_protocol_lrmi_max_threads=512
  #$com_sun_jini_reggie_initialUnicastDiscoveryPort=4174
  $com_gs_zones=''
  $com_gs_grid_secured=false

  # JAVA_OPTION
  $Xloggc = "${config_dir}/logs/gc.log"

  # GSC_JAVA_OPTIONS
  $Xms = '300m'
  $Xmx ='8g'
  $Xmn =''
  $XXCMSInitiatingOccupancyFraction = '60'
}
