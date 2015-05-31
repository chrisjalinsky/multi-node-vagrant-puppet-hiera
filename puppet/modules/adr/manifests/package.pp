define adr::package(
  $r_path = "/usr/bin/R",
  $repo = "http://cran.rstudio.com",
  $dependencies = false
) {

  exec { "install_r_package_$name":
    command => $dependencies ? { 
      true    => "$r_path -e \"install.packages('$name', repos='$repo', dependencies = TRUE)\"",
      default => "$r_path -e \"install.packages('$name', repos='$repo', dependencies = FALSE)\"",
    },
    unless  => "$r_path -q -e '\"$name\" %in% installed.packages()' | grep 'TRUE'",
    timeout => 600,
    require => Package['r-base'],
  }

}