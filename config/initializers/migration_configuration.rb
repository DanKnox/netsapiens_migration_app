# Set the SSH Credentials for each server and city
require 'net/ssh'
::PHONE_REBOOT_URL = 'http://*NDP Server Address*/cfg/sip/notify/'

::CDR_INTERVAL = '1'

::PHONE_CONFIG_SERVER = {}
::PHONE_CONFIG_SERVER[:la] = 'config server name'
::PHONE_CONFIG_SERVER[:ny] = 'config server name'
::PHONE_CONFIG_SERVER[:primary] = 'config server name'

::PRIMARY_CITY = :sd
::PRIMARY_SAS_SERVER = :la

::SSH_CREDENTIALS = {}
::SSH_CREDENTIALS[:sd] = {}
::SSH_CREDENTIALS[:sd][:db]  = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:sd][:nms] = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:sd][:model] = SanDiegoDatabase
::SSH_CREDENTIALS[:sd][:sas_model] = SanDiegoDatabase
::SSH_CREDENTIALS[:sd][:ndp_model] = SanDiegoNdp

::SSH_CREDENTIALS[:la] = {}
::SSH_CREDENTIALS[:la][:db]  = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:la][:db_scp_user] = 'username'
::SSH_CREDENTIALS[:la][:nms] = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:la][:nms_scp_user] = 'username'
::SSH_CREDENTIALS[:la][:model] = LosAngelesDatabase
::SSH_CREDENTIALS[:la][:new_sas] = 'server ip'
::SSH_CREDENTIALS[:la][:sas] = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:la][:sas_scp_user] = 'username'
::SSH_CREDENTIALS[:la][:sas_model] = LosAngelesSasDatabase

::SSH_CREDENTIALS[:ny] = {}
::SSH_CREDENTIALS[:ny][:db]  = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:ny][:db_scp_user] = 'username'
::SSH_CREDENTIALS[:ny][:nms] = ['server ip','username',{:password => 'password'}]
::SSH_CREDENTIALS[:ny][:nms_scp_user] = 'usernaem'
::SSH_CREDENTIALS[:ny][:sas_scp_user] = 'username'
::SSH_CREDENTIALS[:ny][:model] = NewYorkDatabase
::SSH_CREDENTIALS[:ny][:new_sas] = 'server ip'
