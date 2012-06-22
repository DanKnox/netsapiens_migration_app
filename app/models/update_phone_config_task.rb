class UpdatePhoneConfigTask < MigrationTask
  require 'timeout'
  
  def execute
    logger "Updating old phone configs for #{@domain}\n"
    reboot_phones
    SSH_CREDENTIALS[PRIMARY_CITY][:ndp_model].connection.execute "update phones_config set server = '#{PHONE_CONFIG_SERVER[@city]}' where domain = '#{@domain}'"
  end
  
  def rollback
    logger "Rolling back to old phone configs for #{@domain}\n"
    reboot_phones
    SSH_CREDENTIALS[PRIMARY_CITY][:ndp_model].connection.execute "update phones_config set server = '#{PHONE_CONFIG_SERVER[:primary]}' where domain = '#{@domain}'"
  end
  
  def reboot_phones
    retried = false
    logger "Rebooting phones for #{@domain}\n"
    results = SSH_CREDENTIALS[PRIMARY_CITY][:ndp_model].connection.execute "SELECT mac FROM phones_config WHERE domain = '#{@domain}'"
    results.each do |r|
      begin
        logger "Rebooting #{r.first}\n"
        status = Timeout::timeout(7) {
          logger "\nNew Thread for MAC #{r.first}\n"
          RestClient.get PHONE_REBOOT_URL + "event=check-sync&mac=#{r.first}&send=yes" unless retried
        }
      rescue Timeout::Error
        retried = true
        logger "Retrying mac again... netsapiens borked again"
        retry
      end
    end
  end
  
end
