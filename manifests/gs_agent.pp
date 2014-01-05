define xap::gs_agent(
  $name       = 'gs_agent',
  $global_lus = 0,
  $lus        = 0,
  $global_gsm = 0,
  $gsm        = 0,
  $gsc        = 0,
) {

  $args = "gsa.global.lus ${global_lus} gsa.lus ${lus} gsa.global.gsm ${global_gsm} gsa.gsm ${gsm} gsa.gsc ${gsc}"

  $command_line = $kernel ? {
    'windows' => "cmd.exe /c start /min ${xap::params::config_dir}/bin/gs-agent.bat ${args} & type NUL > ${xap::params::config_dir}/bin/gs-agent.lock",
    default   => "${xap::params::config_dir}/bin/gs-agent.sh ${args} > /dev/null 2>&1 & ! cat > ${xap::params::config_dir}/bin/gs-agent.lock"
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
