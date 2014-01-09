define xap::gs_agent(
  $name       = 'gs_agent',
  $global_lus = 0,
  $lus        = 0,
  $global_gsm = 0,
  $gsm        = 0,
  $gsc        = 0,
) {
  $registryPort = $xap::params::com_gigaspaces_system_registryPort + $global_lus + $lus + $global_gsm + $gsm + $gsc -1

  if $kernel == 'windows' {
    # lookup service rule
    windows_firewall::exception { 'LookupService':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'UDP',
      local_port => "${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}",
    }
    # webster rule
    windows_firewall::exception { 'Webster':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gigaspaces_start_httpPort}",
    }
    # LRMI port range rule
    windows_firewall::exception { 'LRMI':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}",
    }
    # JMX port range rule
    windows_firewall::exception { 'JMXPORTS':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gigaspaces_system_registryPort}-${registryPort}",
    }
  } else {
    # lookup service rule
    firewall{"000 open port ${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}":
      port   => "${xap::params::com_sun_jini_reggie_initialUnicastDiscoveryPort}",
      proto  => udp,
      action => accept,
    }
    # webster rule
    firewall{"001 open port ${xap::params::com_gigaspaces_start_httpPort}":
      port   => "${xap::params::com_gigaspaces_start_httpPort}",
      proto  => tcp,
      action => accept,
    }
    # LRMI port range rule
    firewall{"002 open port ${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}":
      port   => "${xap::params::com_gs_transport_protocol_lrmi_bind_port_start}-${xap::params::com_gs_transport_protocol_lrmi_bind_port_end}",
      proto  => tcp,
      action => accept,
    }
    # JMX port range rule
    firewall{"003 open port ${xap::params::com_gigaspaces_system_registryPort}-${registryPort}":
      port   => "${xap::params::com_gigaspaces_system_registryPort}-${registryPort}",
      proto  => tcp,
      action => accept,
    }
  }

  $args = "gsa.global.lus ${global_lus} gsa.lus ${lus} gsa.global.gsm ${global_gsm} gsa.gsm ${gsm} gsa.gsc ${gsc}"

  $command_line = $kernel ? {
    'windows' => "cmd.exe /c start /min ${xap::params::config_dir}/bin/gs-agent.bat ${args} & type NUL > ${xap::params::config_dir}/bin/gs-agent.lock",
    default   => "${xap::params::config_dir}/bin/gs-agent.sh ${args} > /dev/null 2>&1 & ! cat > ${xap::params::config_dir}/bin/gs-agent.lock & ! return 0"
  }

  $path_sperator = $kernel ? {
    'windows' => ';',
    default   => ':',
  }

  # run gs-agent
  exec {"${name}":
       command => "${command_line}" ,
       creates => "${xap::params::config_dir}/bin/gs-agent.lock",
       path    => "$::path${path_sperator}${xap::params::config_dir}/bin${path_sperator}${xap::params::gigaspaces_xap_target}/bin",
  }
}
