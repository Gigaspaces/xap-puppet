define xap::windows_install(
) {

  # require xap::params

  # copy target installation jdk file
  file{"c:\\${xap::params::jdk_file}":
    ensure => file,
    owner  => 'Administrator',
    group  => 'Administrators',
    mode   => 0770,
    source =>  "puppet:///modules/${module_name}/${xap::params::jdk_file}",
  } ~>

  # execute jdk install
  windows_package { "Java ${xap::params::jdk_version} Update ${xap::params::jdk_update}":
    ensure          => installed,
    source          => "c:\\${xap::params::jdk_file}",
    install_options => ['/s'],
  }

}
