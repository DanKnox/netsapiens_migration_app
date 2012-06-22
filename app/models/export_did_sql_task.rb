class ExportDidSqlTask < MigrationTask
  EXPORT_TABLES = [:dialplan_config]
                   
  def execute
    logger "Exporting DID Sql for #{@domain}\n"
    EXPORT_TABLES.each do |table|
      logger "Sql Output for #{table}\n"
      SSH_CREDENTIALS[PRIMARY_CITY][:model].connection.execute send( table )
    end
  end
  
  def dialplan_config
    "SELECT * INTO OUTFILE '/tmp/#{@domain}-did/dialplan_config' FROM `dialplan_config` WHERE `to_host` LIKE '#{@domain}' and dialplan = 'DID Table'"
  end
  
  def export_tables
    EXPORT_TABLES
  end
  
end