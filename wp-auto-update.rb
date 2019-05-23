#
# wp-auto-update.rb
#
# Copyright 2015 -, tecking
# Version 0.6.4
#
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
require 'open3'
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
  'wp db export `wp eval "echo WP_CONTENT_DIR . DIRECTORY_SEPARATOR . DB_NAME;"`.sql && \
   wp core update --minor && \
   wp plugin update --all && \
   wp theme update --all && \
   wp core language update && \
   wp cli update --yes'


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
  
  user['wp'] = wp.dup
  if user['force']
    user['wp'].sub!(/wp core update --minor/, 'wp core update --force')
  end
  
  if user['command']
    if user['command']['search'] && user['command']['replace']
      user['wp'].gsub!(user['command']['search'], user['command']['replace'])
    end
  end

  stdout = ''
  stderr = ''

  puts "### #{user['name']} ###"
  
  Net::SSH.start(user['host'], user['user'], option) do |ssh|
    ssh.exec!("#{bash}; cd #{user['dir']}; #{user['wp']}; exit") do |channel, stream, data|
      stdout << data if stream == :stdout
      stderr << data if stream == :stderr
    end
  end

  wget_out, wget_err = Open3.capture3("wget --spider -nv --timeout 60 -t 3 #{user['url']}")

  puts stdout if stdout.length != 0
  puts stderr if stderr.length != 0
  puts wget_err
  puts

  mail_body << "### #{user['name']} ###\n"
  mail_body << stdout.force_encoding('utf-8')
  mail_body << stderr.force_encoding('utf-8')
  mail_body << wget_err
  mail_body << "\n"

end


#
# Send check results.
#

date = Time.now

mail = Mail.new do
  from    admin['from']
  to      admin['to']
  subject date.strftime(admin['subject'])
  body    mail_body
end

mail.charset = 'utf-8'
mail.delivery_method(:smtp,
  enable_starttls_auto: false
)
mail.deliver

puts 'Check results has been mailed.'
