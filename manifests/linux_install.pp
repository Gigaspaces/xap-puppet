define xap::linux_install(
) {
    include jdk7
    require xap::params

    $x64 = $hardwaremodel ? {
      'i686'   => false,
      default => true,
    }

    jdk7::install7{ "${xap::params::jdk_home}":
                      version               => "${xap::params::jdk_version}u${xap::params::jdk_update}" ,
                      fullVersion           => "${xap::params::jdk_home}",
                      alternativesPriority  => 18000,
                      x64                   => $x64,
                      downloadDir           => "/install",
                      urandomJavaFix        => false,
                      sourcePath            => "puppet:///modules/xap"
    }
}
