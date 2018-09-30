class puppet-cron (
  String $git_repo  = "git@github.com/lubomirkamensky/puppet-modules.git"
){

  // Let's make sure the Puppet daemon isn't running.
  service { "puppet":
    ensure => stopped,
    enable => false,
  } ->

  // Pull the latest commits to our Puppet module repository efvery 4 minutes.
  cron { 'puppet-pull':
    ensure => present,
    command => "cd /etc/puppet ; /usr/bin/git fetch ${git_repo} ; /usr/bin/git checkout FETCH_HEAD -- environments/production/modules ; /usr/bin/git checkout FETCH_HEAD -- manifests/templates ; /usr/bin/git checkout FETCH_HEAD -- files",
    user => 'root',
    minute => '*/4',
  } ~>

  cron { 'puppet-apply':
    ensure => present,
    command => "/usr/bin/puppet apply /etc/puppet/site.pp"
    user => 'root',
    minute => '*/5',
  }
}
