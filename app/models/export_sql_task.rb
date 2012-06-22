class ExportSqlTask < MigrationTask
  EXPORT_TABLES = [:domains_config, :subscriber_config, :registrar_config, :feature_config, :call_list,
                   :phone_book, :callqueue_config, :huntgroup_config, :huntgroup_entry_config, :operator,
                   :call_disposition, :dialplans, :dialplan_config, :dialpolicies, :dial_policy_config, :cdr]
                   
  def execute
    logger "Exporting Sql for #{@domain}\n"
    EXPORT_TABLES.each do |table|
      logger "Sql Output for #{table}\n"
      SSH_CREDENTIALS[PRIMARY_CITY][:model].connection.execute send( table )
    end
  end
  
  def domains_config
    "SELECT * INTO OUTFILE '/tmp/#{@domain}/domains_config' FROM domains_config WHERE domain = '#{@domain}'"
  end
  
  def subscriber_config
    "select * INTO OUTFILE '/tmp/#{@domain}/subscriber_config' from subscriber_config where aor_host = '#{@domain}'"
  end
  
  def registrar_config
    "select * INTO OUTFILE '/tmp/#{@domain}/registrar_config' from registrar_config where subscriber_domain = '#{@domain}'"
  end
  
  def feature_config
    "SELECT * INTO OUTFILE '/tmp/#{@domain}/feature_config' FROM feature_config WHERE callee_match LIKE '%#{@domain}%'"
  end
  
  def call_list
    "select * INTO OUTFILE '/tmp/#{@domain}/call_list' from call_list where domain = '#{@domain}'"
  end
  
  def phone_book
    "select * INTO OUTFILE '/tmp/#{@domain}/phone_book' from phone_book where domain = '#{@domain}'"
  end
  
  def callqueue_config
    "select * INTO OUTFILE '/tmp/#{@domain}/callqueue_config' from callqueue_config where domain = '#{@domain}'"
  end
  
  def huntgroup_config
    "select * INTO OUTFILE '/tmp/#{@domain}/huntgroup_config' from huntgroup_config where huntgroup_domain = '#{@domain}'"
  end
  
  def huntgroup_entry_config
    "select * INTO OUTFILE '/tmp/#{@domain}/huntgroup_entry_config' from huntgroup_entry_config where huntgroup_domain = '#{@domain}'"
  end
  
  def operator
    "select * INTO OUTFILE '/tmp/#{@domain}/operator' from operator where queue_domain = '#{@domain}'"
  end
  
  def call_disposition
    "select * INTO OUTFILE '/tmp/#{@domain}/call_disposition' from call_disposition where domain = '#{@domain}'"
  end
  
  def dialplans
    "select * INTO OUTFILE '/tmp/#{@domain}/dialplans' from dialplans where domain = '#{@domain}'"
  end
  
  def dialplan_config
    "select * INTO OUTFILE '/tmp/#{@domain}/dialplan_config' from dialplan_config where domain = '#{@domain}'"
  end
  
  def dialpolicies
    "select * INTO OUTFILE '/tmp/#{@domain}/dialpolicies' from dialpolicies where domain = '#{@domain}'"
  end
  
  def dial_policy_config
    "select * INTO OUTFILE '/tmp/#{@domain}/dial_policy_config' from dial_policy_config where domain = '#{@domain}'"
  end
  
  def cdr
    "select * INTO OUTFILE '/tmp/#{@domain}/cdr' from cdr where (orig_domain = '#{@domain}' or term_domain = '#{@domain}') and (time_start > date_sub( utc_timestamp(), interval #{CDR_INTERVAL} day ))" 
  end
  
  def export_tables
    EXPORT_TABLES
  end
  
end