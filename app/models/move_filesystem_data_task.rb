class MoveFilesystemDataTask < MigrationTask
  require 'net/ssh'
  
  def execute
    logger "Copying Filesystem Data for #{@domain}\n"
    copy_filesystem_data_to_city
  end
  
  def copy_filesystem_data_to_city
    logger "SSH TO #{@city}\n"
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:nms] ) do |ssh|
      logger "Connected!\n"
      
      # SCP Files to Appropriate Server/City
      ssh.exec!("scp -r /usr/local/NetSapiens/SiPbx/data/#{@domain}/ #{SSH_CREDENTIALS[@city][:nms_scp_user]}@#{SSH_CREDENTIALS[@city][:nms].first}:/usr/local/NetSapiens/SiPbx/data/")
      
      logger "Files copied!\n"
    end
  end
end
