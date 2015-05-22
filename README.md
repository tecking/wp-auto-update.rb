# wp-auto-update.rb

## What's this?

"wp-auto-update.rb" is a ruby script to update WordPress websites. Once you setup a configuration file (YAML format), it cruises multiple websites and updates WordPress automatically.

## Features

It updates WordPress websites the following processes.

1. Exports database
2. Updates WordPress core files
3. Updates all plugins (only distributed on [plugins directory](https://wordpress.org/plugins/))
4. Updates all themes (only distributed on [themes directory](https://wordpress.org/themes/))
5. Checks the website is whether in active or inactive

## Requires

### Local host

* Ruby
* [Net::SSH package](https://github.com/net-ssh/net-ssh) (apply with ``gem install net-ssh``)
* Mail package (apply with ``gem install mail``)

### Remote host

* SSH access is allowed (also possible SSH public key authentication)
* [WP-CLI](http://wp-cli.org/)

#### Related script

* [wp-cli.setup.sh](https://github.com/tecking/wp-cli.setup.sh)  
A shell script to install "WP-CLI" into common hosting servers.

## Installation and usage

1. ``git clone`` or download and expand ZIP file
2. Rename "config-sample.yml" to "config.yml" (is the configuration file)
3. Setup "config.yml"
4. Execute ``ruby wp-auto-update.rb``

## Settings for the configuration file (config.yml)
 
Please refer to "config-sample.yml". (*) = required.

### admin section

* from  
E-mail address of check results sender (*)
* to  
E-mail address that you want to receive (*)
* subject  
Check results subject (also possible ISO 8601 date format)

### users section

* name  
Identify name (*)
* url  
Site URL (*)
* host  
Hostname (FQDN, also possible IP address) (*)
* user  
Username (*)
* pass  
Password (you can omit under SSH public key authentication)
* port  
SSH port (*)
* key  
Path to the private key file (it requires under SSH public key authentication)
* phrase  
Passphrase (it requires under SSH public key authentication)
* dir  
Path to the directory WordPress is installed (*)

## Option

With ``-f`` option, you can choose configuration files. If it is empty, the script reads "config.yml" in the same directory.

### Example

``ruby wp-auto-update.rb -f config.foobar.yml``

## Notice

* Please use At Your Own Risk
* Tested environment (hosting servers)
 * [SAKURA Rental Server](http://www.sakura.ne.jp/) (Japan)
 * [Heteml](http://heteml.jp) (Japan)

## Changelog

* 0.2.0 (2015-05-19)
 * Sending update results via E-mail
 * Alive checker
* 0.1.0 (2015-05-15)
 * Opening to the public

## License

[MIT License](http://opensource.org/licenses/mit-license.php)