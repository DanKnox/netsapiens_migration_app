class ExportConferenceSqlTask < MigrationTask
  EXPORT_TABLES = [:conference_config,:participant_config,:gateway_config,:cdr]
  
  def execute
    logger "Exporting Conference Sql for #{@domain}\n"
    EXPORT_TABLES.each do |table|
      logger "Sql Output for #{table}\n"
      SSH_CREDENTIALS[PRIMARY_CITY][:model].connection.execute send( table )
    end
  end
  
  def conference_config
    "select * INTO OUTFILE '/tmp/#{@domain}-conference/conference_config' from NcsDomain.conference_config where domain = '#{@domain}'"
  end
  
  def participant_config
    "select * INTO OUTFILE '/tmp/#{@domain}-conference/participant_config' from NcsDomain.participant_config where conference_match like '%#{@domain}%'"
  end
  
  def gateway_config
    "select * INTO OUTFILE '/tmp/#{@domain}-conference/gateway_config' from NcsDomain.gateway_config where aor like '%#{@domain}%'"
  end
  
  def cdr
    "select * INTO OUTFILE '/tmp/#{@domain}-conference/cdr' from NcsDomain.cdr where (time_start > date_sub(utc_timestamp(), interval #{CDR_INTERVAL} day)) and (orig_from_uri like '%#{@domain}%' or term_to_uri like '%#{@domain}%')"
  end
  
  def export_tables
    EXPORT_TABLES
  end
  
end