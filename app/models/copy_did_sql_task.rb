class CopyDidSqlTask < MigrationTask
  require 'net/ssh'
  
  def execute
    logger "Copying Sql for #{@domain}\n"
    copy_sql_to_city
  end
  
  def copy_sql_to_city
    logger "SSH TO #{@city}\n"
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      logger "Connected!\n"
      
      # SCP Files to Appropriate Server/City
      ssh.exec!("scp -r /tmp/#{@domain}-did/ #{SSH_CREDENTIALS[@city][:db_scp_user]}@#{SSH_CREDENTIALS[@city][:db].first}:/tmp")
      ssh.exec!("scp -r /tmp/#{@domain}-did/ #{SSH_CREDENTIALS[PRIMARY_SAS_SERVER][:sas_scp_user]}@#{SSH_CREDENTIALS[PRIMARY_SAS_SERVER][:sas].first}:/tmp")
      logger "Files copied. Removing Directory!\n"
      ssh.exec!("rm -rf /tmp/#{@domain}-did") unless @domain.nil? || @domain == '*' || @domain == '.' || @domain == '..'
    end
  end
  
  def rollback
    
  end
  
end