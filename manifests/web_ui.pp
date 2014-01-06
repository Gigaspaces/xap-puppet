define xap::web_ui (
  $web_name = 'gs_webui',
) {
  
  firewall{'100 open port 8099':
    port   => 8099,
    proto  => tcp,
    action => accept,
  }

  $command_line = $kernel ? {
    'windows' => "cmd.exe /c start /min ${xap::params::config_dir}/bin/gs-webui.bat & type NUL > ${xap::params::config_dir}/bin/gs-webui.lock",
    default   => "${xap::params::config_dir}/bin/gs-webui.sh > dev /null 2>&1 & ! cat > ${xap::params::config_dir}/bin/gs-webui.lock"
  }

  $path_sperator = $kernel ? {
    'windows' => ';',
    default   => ':',
  }

  # run gs-webui
  exec {"${web_name}":
       command  => $command_line ,
       path   => "$::path${path_sperator}${xap::params::config_dir}/bin${path_sperator}${gigaspaces_xap_target}/bin",
  }
}
