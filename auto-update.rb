#
# auto-update.rb
#
# Copyright 2015 -, tecking
# Licensed under the MIT License.
#
# NOTICE
# It requires the Net::SSH package( https://github.com/net-ssh/net-ssh ).
# Please install it before execution.
# 

#
# Load module(s) and package(s).
#

require 'net/ssh'
require 'yaml'
require 'optparse'


#
# Parse configuration file.
#

params = ARGV.getopts('f:')

if params['f'].nil? then
  config_file = 'config.yml'
else
  config_file = params['f']
end

config = YAML.load_file(config_file)
users = config['users']


#
# Set up command(s).
#

bash =
  '[ -e ~/.bash_profile ] && source ~/.bash_profile'

wp =
  'wp db export && \
   wp core update && \
   wp plugin update --all && \
   wp theme update --all'


#
# Execute update process.
#

users.each do |user|

  option = {
    :password => user['pass'],
    :port => user['port'],
    :paranoid => false,
    :user_known_hosts_file => '/dev/null',
    :keys => user['key'],
    :passphrase => user['phrase']
  }

  stdout = ''
  stderr = ''

  puts "### #{user['name']} ###"
  
  Net::SSH.start(user['host'], user['user'], option) do |ssh|
    ssh.exec!("#{bash}; cd #{user["dir"]}; #{wp}; exit") do |channel, stream, data|
      stdout << data if stream == :stdout
      stderr << data if stream == :stderr
    end
  end

  print "\e[32m"; puts stdout if stdout.length != 0; print "\e[0m"
  print "\e[31m"; puts stderr if stderr.length != 0; print "\e[0m"
  puts

end