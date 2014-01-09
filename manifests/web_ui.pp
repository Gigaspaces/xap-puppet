define xap::web_ui (
  $web_name = 'gs_webui',
) {
  if $kernel =='windows' {
    windows_firewall::exception { 'WINRM':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gs_webui_port}",
    }
  } else {
    firewall{"100 open port ${xap::params::com_gs_webui_port}":
      port   => "${xap::params::com_gs_webui_port}",
      proto  => tcp,
      action => accept,
    }
  }
  $command_line = $kernel ? {
    'windows' => "cmd.exe /c start /min ${xap::params::config_dir}/bin/gs-webui.bat & type NUL > ${xap::params::config_dir}/bin/gs-webui.lock",
    default   => "${xap::params::config_dir}/bin/gs-webui.sh > dev /null 2>&1 & ! cat > ${xap::params::config_dir}/bin/gs-webui.lock & ! return 0"
  }

  $path_sperator = $kernel ? {
    'windows' => ';',
    default   => ':',
  }

  # run gs-webui
  exec {"${web_name}":
       command  => $command_line ,
       creates => "${xap::params::config_dir}/bin/gs-webui.lock",
       path   => "$::path${path_sperator}${xap::params::config_dir}/bin${path_sperator}${gigaspaces_xap_target}/bin",
  }
}
