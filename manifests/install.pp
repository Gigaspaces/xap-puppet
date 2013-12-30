define xap::install(
  $product    = 'premium',
  $version    = '9.6.0',
  $release    = 'ga',
  $build      = 'b9900',
) {

  #download xap archive
  file {"/usr/src/gigaspaces-xap-${product}-${version}-${release}-${build}.zip":
    ensure => file,
    source =>  "puppet:///modules/${module_name}/gigaspaces-xap-${product}-${version}-${release}-${build}.zip",
  }

  #extract xap archive
  archive::extract { "gigaspaces-xap-${product}-${version}-${release}-${build}":
    ensure    => present,
    target    => '/opt',
    extension => 'zip',
    require   => File["/usr/src/gigaspaces-xap-${product}-${version}-${release}-${build}.zip"],
  }
}
