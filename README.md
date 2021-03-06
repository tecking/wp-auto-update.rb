# wp-auto-update.rb

## What's this?

"wp-auto-update.rb" is a ruby script to update WordPress websites. Once you setup a configuration file (YAML format), it cruises multiple websites and updates WordPress automatically.

## Features

It updates WordPress websites the following processes.

1. Exports database
2. Updates WordPress core files
3. Updates all plugins (only distributed on [plugins directory](https://wordpress.org/plugins/))
4. Updates all themes (only distributed on [themes directory](https://wordpress.org/themes/))
5. Updates WP-CLI
6. Checks the website is whether in active or inactive

## Requires

### Local host

* SSH access is allowed
* [WP-CLI](http://wp-cli.org/)
* Ruby
  * [Net::SSH package](https://github.com/net-ssh/net-ssh) (apply with ``gem install net-ssh``)
  * Mail package (apply with ``gem install mail``)

### Remote host

* SSH access is allowed (also possible SSH public key authentication)
* WP-CLI

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
* force  
Force updating (wp core update --force) either or not (boolean, default = false)
* command  
Specify to run PHP or WP-CLI with full path

## Option

Execute with ``-f`` option, you can choose any configuration files. If it is empty, the script reads "config.yml" in the same directory.

### Example

``ruby wp-auto-update.rb -f config.foobar.yml``

## Notice

* Please use At Your Own Risk
* Tested environment (hosting servers)
  * [SAKURA Rental Server](https://www.sakura.ne.jp/) (Japan)
  * [Heteml](https://heteml.jp/) (Japan)
  * [LOLIPOP! Rentel Server](https://lolipop.jp/) (Japan)
  * [XSERVER](https://www.xserver.ne.jp/) (Japan)

## Changelog

* 0.6.5 (2020-04-02)
  * Updated ``wp language`` command
* 0.6.4 (2019-05-23)
  * Fixed ``bash`` section
* 0.6.3 (2019-05-17)
  * Added ``command`` configuration
  * Removed ``bash`` section
* 0.6.2 (2018-02-11)
  * Fixed ``wp core update`` command
* 0.6.1 (2018-02-11)
  * Fixed ``wp core update`` command
* 0.6.0 (2018-02-10)
  * Updated ``wp core update`` command
  * Added ``force`` configuration
* 0.5.2 (2018-02-09)
  * Changed GPL license to MIT
* 0.5.1 (2017-06-21)
  * Fixed ``wp cli update`` command
* 0.5.0 (2017-03-17)
  * Updated ``wp core update`` command
  * Added ``wp core language`` command
* 0.4.0 (2017-02-23)
  * Updated ``wp db export`` command
  * Changed MIT license to GPL
* 0.3.0 (2015-12-10)
  * Added ``wp cli update`` command
* 0.2.0 (2015-05-19)
  * Sending update results via E-mail
  * Added alive checker
* 0.1.0 (2015-05-15)
  * Opening to the public

## License

[MIT License](http://opensource.org/licenses/mit-license.php)
