define xap::configure(
) {


    file {"${xap::params::config_dir}":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/log":
        ensure => directory,
    } ->

    file {"${xap::params::config_dir}/deploy":
        ensure => directory,
    }

    file {"${xap::params::config_dir}/work":
        ensure => directory,
    }

    # configure setenv
    file{"${xap::params::config_dir}/setenv.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/setenv.${xap::params::extension}.erb"),
    } ->

    # configure gs-agent
    file{"${xap::params::config_dir}/gs-agent.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gs-agent.${xap::params::extension}.erb"),
    } ->

    # configure gsc
    file{"${xap::params::config_dir}/gsc.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gsc.${xap::params::extension}.erb"),
    } ->


    # configure gs
    file{"${xap::params::config_dir}/gs.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gs.${xap::params::extension}.erb"),
    } ->

    # configure gs-webui
    file{"${xap::params::config_dir}/gs-webui.${xap::params::extension}":
      ensure  => present,
      mode    => 766,
      content =>  template("${module_name}/gs-webui.${xap::params::extension}.erb"),
    }
}
