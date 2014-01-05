define xap::configure(
) {


    file {"${xap::params::config_dir}":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/bin":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/tools":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/tools/gs-webui":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/logs":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/deploy":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/work":
        ensure => directory,
    } ->

    # configure setenv
    file{"${xap::params::config_dir}/bin/setenv.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/setenv.${xap::params::extension}.erb"),
    } ->

    # configure gs-agent
    file{"${xap::params::config_dir}/bin/gs-agent.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gs-agent.${xap::params::extension}.erb"),
    } ->

    # configure gsc
    file{"${xap::params::config_dir}/bin/gsc.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gsc.${xap::params::extension}.erb"),
    } ->


    # configure gs
    file{"${xap::params::config_dir}/bin/gs.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gs.${xap::params::extension}.erb"),
    } ->

    # configure gs-webui
    file{"${xap::params::config_dir}/bin/gs-webui.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gs-webui.${xap::params::extension}.erb"),
    } ->

    file{"${xap::params::config_dir}/tools/gs-webui/gs-webui.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/tools/gs-webui/gs-webui.${xap::params::extension}.erb"),
    } ->

    file{"${xap::params::config_dir}/tools/gs-webui/${xap::params::gs_webui_war_file}":
      ensure => file,
      source => "${xap::params::gigaspaces_xap_target}/tools/gs-webui/${xap::params::gs_webui_war_file}",
    }
}
