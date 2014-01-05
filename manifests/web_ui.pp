define xap::web_ui (
  $name = 'gs_webui'
) {
  $command_line = $kernel ? {
    'windows' => "start /min ${xap::params::config_dir}/gs-webui.bat",
    default   => "${xap::params::config_dir}/gs-webui.sh > dev /null 2>&1 &"
  }

  $path_sperator = $kernel ? {
    'windows' => ';',
    default   => ':',
  }

  # run gs-webui
  exec {"${name}":
       command  => $command_line ,
       path   => "$::path${path_sperator}${xap::params::config_dir}/bin${path_sperator}${gigaspaces_xap_target}/bin",
  }
}
