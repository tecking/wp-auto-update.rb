#
# auto-update.rb
#
# Copyright 2015 -, tecking
# Licensed under the MIT License.
#
# NOTICE
# It requires the following gem packages.
#   - Net::SSH ( https://github.com/net-ssh/net-ssh )
#   - Mail
# Please install them before execution.
#


#
# Initialize
#

require 'net/ssh'
require 'yaml'
require 'optparse'
require 'mail'
require 'date'

mail_body = ''


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
admin = config['admin']
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

  mail_body << "### #{user['name']} ###\n"
  mail_body << stdout.force_encoding('utf-8')
  mail_body << stderr.force_encoding('utf-8')
  mail_body << "\n"

end


#
# Send result mail.
#

date = Time.now

mail = Mail.new do
  from    admin['from']
  to      admin['to']
  subject date.strftime(admin['subject'])
  body    mail_body
end

mail.charset = 'utf-8'
mail.deliver

puts 'Result mail has been delivered.'
