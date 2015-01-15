# installs the tools and sets up the environment for developing puppet
class puppet_dev_env (
  $user,
  $user_home_dir = "/home/${user}",
){
  File {
    owner => $user,
    group => $user,
    mode  => '0662',
  }
  package { 'vim' :
    ensure => present,
  }
  file { "${user_home_dir}/.vimrc" :
    ensure  => file,
    source  => 'puppet:///modules/puppet_dev_env/vimrc',
    require => Package['vim'],
  }
  file { "${user_home_dir}/.vim" :
    ensure  => directory,
    mode    => '0775',
    require => Package['vim'],
  }
  file { "${user_home_dir}/.vim/autoload" :
    ensure  => directory,
    mode    => '0775',
    require => File["${user_home_dir}/.vim"],
  }
  file { "${user_home_dir}/.vim/bundle" :
    ensure  => directory,
    mode    => '0775',
    require => File["${user_home_dir}/.vim"],
  }
  # install pathogen
  file { "${user_home_dir}/.vim/autoload/pathogen.vim" :
    ensure  => file,
    source  => 'puppet:///modules/puppet_dev_env/pathogen.vim',
    require => File["${user_home_dir}/.vim/autoload"],
  }
  # use git to pull packages for pathogen
  package { 'git' :
    ensure => present,
  }
  # Install nerd tree
  exec { 'nerdtree' :
    command => '/usr/bin/git clone git://github.com/scrooloose/nerdtree.git',
    cwd     => "${user_home_dir}/.vim/bundle",
    require => [File["${user_home_dir}/.vim/autoload/pathogen.vim",
      "${user_home_dir}/.vim/bundle"],
      Package['git']],
    creates => "${user_home_dir}/.vim/bundle/nerdtree",
  }
  # Adds support for nerd tree to all open tabs
  exec { 'nerdtreetabs' :
    command => '/usr/bin/git clone https://github.com/jistr/vim-nerdtree-tabs.git',
    cwd     => "${user_home_dir}/.vim/bundle",
    require => Exec['nerdtree'],
    creates => "${user_home_dir}/.vim/bundle/vim-nerdtree-tabs",
  }
  # Helps for aligning text
  exec { 'tabular' :
    command => '/usr/bin/git clone git://github.com/godlygeek/tabular.git',
    cwd     => "${user_home_dir}/.vim/bundle",
    require => [File["${user_home_dir}/.vim/autoload/pathogen.vim",
      "${user_home_dir}/.vim/bundle"],
      Package['git']],
    creates => "${user_home_dir}/.vim/bundle/tabular",
  }
  exec { 'numbers' :
    command => '/usr/bin/git clone https://github.com/myusuf3/numbers.vim.git',
    cwd     => "${user_home_dir}/.vim/bundle/",
    require => [File["${user_home_dir}/.vim/autoload/pathogen.vim",
      "${user_home_dir}/.vim/bundle"],
      Package['git']],
    creates => "${user_home_dir}/.vim/bundle/numbers.vim",
  }
  # Puppet syntax
  exec { 'vim-puppet`' :
    command => '/usr/bin/git clone git://github.com/rodjek/vim-puppet.git',
    cwd     => "${user_home_dir}/.vim/bundle",
    require => [File["${user_home_dir}/.vim/autoload/pathogen.vim",
      "${user_home_dir}/.vim/bundle"],
      Package['git']],
    creates => "${user_home_dir}/.vim/bundle/vim-puppet",
  }
  # install the puppet-test which runs puppet parser validate and
  # puppet-lint
  package { 'puppet-lint' :
    ensure => present,
  }
  file { '/usr/local/bin/puppet-test':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'puppet:///modules/puppet_dev_env/puppet-test',
    require => Package['puppet-lint'],
  }
  package { 'graphviz' :
    ensure => present,
  }
  file { '/usr/local/bin/graph-dot':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'puppet:///modules/puppet_dev_env/graph-dot',
    require => Package['graphviz'],
  }
}
