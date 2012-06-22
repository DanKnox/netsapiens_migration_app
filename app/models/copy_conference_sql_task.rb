class CopyConferenceSqlTask < MigrationTask
  require 'net/ssh'
  
  def execute
    logger "Copying Conference Sql for #{@domain}\n"
    copy_sql_to_city
  end
  
  def copy_sql_to_city
    logger "SSH TO #{@city}\n"
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      logger "Connected!\n"
      
      # SCP Files to Appropriate Server/City
      ssh.exec!("scp -r /tmp/#{@domain}-conference/ #{SSH_CREDENTIALS[@city][:db_scp_user]}@#{SSH_CREDENTIALS[@city][:db].first}:/tmp")
      
      logger "Files copied. Removing Directory!\n"
      ssh.exec!("rm -rf /tmp/#{@domain}-conference") unless @domain.nil? || @domain == '*' || @domain == '.' || @domain == '..'
    end
  end
    
end