define xap::web_ui (
  $web_name = 'gs_webui',
) {
  if $kernel =='windows' {
    windows_firewall::exception { 'GS_WEB_UI':
      ensure     => present,
      direction  => 'in',
      action     => 'Allow',
      enabled    => 'yes',
      protocol   => 'TCP',
      local_port => "${xap::params::com_gs_webui_port}",
      display_name =>  'GS web ui',
      description  => "Inbound rule for GS web ui. [TCP ${xap::params::com_gs_webui_port}]",
    }
  } else {
    firewall{"004 open port ${xap::params::com_gs_webui_port}":
      port   => "${xap::params::com_gs_webui_port}",
      proto  => tcp,
      action => accept,
    }
  }
  $command_line = $kernel ? {
    'windows' => "cmd.exe /c start /min ${xap::params::config_dir}/bin/gs-webui.bat & start /min >&2 pause  >> ${xap::params::config_dir}/bin/gs-webui.lock",
    default   => "${xap::params::config_dir}/bin/gs-webui.sh > /dev/null 2>&1 & ! return 0"
  }
  $path_sperator = $kernel ? {
    'windows' => ';',
    default   => ':',
  }

  $onlyif_cmd = $kernel ? {
   'windows' => "gs-webui.lock",
   default=> "\"gs\\-webui\""
  }

  # run gs-webui
  exec {"${web_name}":
       command  => $command_line ,
       onlyif   => "${xap::params::config_dir}/bin/locker.${xap::params::extension} ${onlyif_cmd}",
       path   => "$::path${path_sperator}${xap::params::config_dir}/bin${path_sperator}${gigaspaces_xap_target}/bin",
  }
}
