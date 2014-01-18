define xap::gs_agent(
  $name       = 'gs_agent',
  $g_lus = 0,
  $l_lus        = 0,
  $g_gsm = 0,
  $l_gsm        = 0,
  $l_gsc        = 0,
) {
  $registryPort = $xap::params::com_gigaspaces_system_registryPort + $g_lus + $l_lus + $g_gsm + $l_gsm + $l_gsc -1

  $args = "gsa.global.lus ${g_lus} gsa.lus ${l_lus} gsa.global.gsm ${g_gsm} gsa.gsm ${l_gsm} gsa.gsc ${l_gsc}"

  $command_line = $kernel ? {
    'windows' => "cmd.exe /c start /min ${xap::params::config_dir}/bin/gs-agent.bat ${args} & start /min >&2 pause  >> ${xap::params::config_dir}/bin/gs-agent.lock",
     default   => "${xap::params::config_dir}/bin/gs-agent.sh ${args} > /dev/null 2>&1 & ! return 0",
 }

 $onlyif_cmd = $kernel ? {
   'windows' => "gs-agent.lock",
   default=> "\"gs\\-agent\""
 }

 $path_sperator = $kernel ? {
    'windows' => ';',
    default   => ':',
  }

  if $kernel == 'windows' {
    # lookup service rule
    windows_firewall::exception { 'LookupService':
    ensure         => present,
      direction    => 'in',
      action       => 'Allow',
      enabled      => 'yes',
      protocol     => 'UDP',
      local_port   => "${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}",
      display_name =>  'Lookup service',
      description  => "Inbound rule for Lookup service. [UDP ${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}]",
    } ->
    # webster rule
    windows_firewall::exception { 'Webster':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gigaspaces_start_httpPort}",
      display_name =>  'Webster',
      description  => "Inbound rule for Webster. [TCP ${xap::params::com_gigaspaces_start_httpPort}]",
    } ->
    # LRMI port range rule
     windows_firewall::exception { 'LRMI':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}",
      display_name =>  'lrmi bind port',
      description  => "Inbound rule for lrmi bind port. [TCP ${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}]",
    } ->
    # JMX port range rule
        windows_firewall::exception { 'JMXPORTS':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gigaspaces_system_registryPort}-${registryPort}",
      display_name =>  'JMX registry ports',
      description  => "Inbound rule for JMX registry ports. [TCP {xap::params::com_gigaspaces_system_registryPort}-${registryPort}]",
    }
  } else {
    # lookup service rule
    firewall{"000 open port ${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}":
      port   => "${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}",
      proto  => udp,
      action => accept,
    } ->
    # webster rule
    firewall{"001 open port ${xap::params::com_gigaspaces_start_httpPort}":
      port   => "${xap::params::com_gigaspaces_start_httpPort}",
      proto  => tcp,
      action => accept,
    } ->
    # LRMI port range rule
    firewall{"002 open port ${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}":
      port   => "${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}",
      proto  => tcp,
      action => accept,
    } ->
    # JMX port range rule
    firewall{"003 open port ${xap::params::com_gigaspaces_system_registryPort}-${registryPort}":
      port   => "${xap::params::com_gigaspaces_system_registryPort}-${registryPort}",
      proto  => tcp,
      action => accept,
    }
  }

  # run gs-agent
  exec {"${name}":
       command  => "${command_line}" ,
       onlyif   => "${xap::params::config_dir}/bin/locker.${xap::params::extension} ${onlyif_cmd}",
       path     => "$::path${path_sperator}${xap::params::config_dir}/bin${path_sperator}${xap::params::gigaspaces_xap_target}/bin",
  }
}
