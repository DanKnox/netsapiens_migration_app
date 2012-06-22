class ActivateDidSqlTask < MigrationTask
  
  def execute
    SSH_CREDENTIALS[@city][:model].connection.execute send( :dialplan_update )
    
    # Rewrite dial plan to point to LA SAS
    update_numbers
  end
  
  def update_numbers
    numbers = []
    results = SSH_CREDENTIALS[PRIMARY_CITY][:model].connection.execute find_number_sql
    results.each do |r|
      numbers << r.first
      primary_update r.first
      SSH_CREDENTIALS[PRIMARY_CITY][:sas_model].connection.execute send( :dialplan_update_for, r.first )
    end
    numbers.each do |num|
      sas_update num
      logger "Updating New Primary SAS Server\n"
      SSH_CREDENTIALS[PRIMARY_SAS_SERVER][:sas_model].connection.execute send( :dialplan_update_for, num )
    end
  end
  
  def dialplan_update
    "INSERT INTO dialplan_update SELECT '',matchrule,match_from,dow,tod_from,tod_to,valid_from,valid_to,responder,parameter,to_scheme,to_user,to_host,from_name,from_scheme,from_user,
    from_host,dialplan,domain,plan_description,'no','pending' FROM dialplan_config WHERE dialplan='DID Table' and to_host = '#{@domain}'"
  end
  
  def dialplan_update_for(number)
    "INSERT INTO dialplan_update SELECT '',matchrule,match_from,dow,tod_from,tod_to,valid_from,valid_to,responder,parameter,to_scheme,to_user,to_host,from_name,from_scheme,from_user,
    from_host,dialplan,domain,plan_description,'no','pending' FROM dialplan_config WHERE dialplan='DID Table' and `dialplan_config`.`matchrule` = '#{number}'"
  end
  
  def find_number_sql
    "SELECT * FROM  `dialplan_config` WHERE  `to_host` LIKE  '#{@domain}' AND  `dialplan` LIKE  'did table'"
  end
  
  def primary_update(number)
    SSH_CREDENTIALS[PRIMARY_CITY][:sas_model].connection.execute send( :primary_update_sql, number )
  end
  
  def primary_update_sql(number)
    "UPDATE  `SiPbxDomain`.`dialplan_config` SET  `responder` =  'sip:start@to-connection',
    `to_user` =  '[*]',
    `to_host` =  'lasas.vintalk.com' WHERE  `dialplan_config`.`matchrule` =  '#{number}' AND  `dialplan_config`.`dialplan` =  'DID Table';"
  end
  
  def sas_update(number)
    SSH_CREDENTIALS[PRIMARY_SAS_SERVER][:sas_model].connection.execute send( :sas_update_sql, number )
  end
  
  def sas_update_sql(number)
    "UPDATE  `SiPbxDomain`.`dialplan_config` SET  `responder` =  'sip:start@to-connection',
    `to_user` =  '[*]',
    `to_host` =  '#{SSH_CREDENTIALS[@city][:new_sas]}' WHERE  `dialplan_config`.`matchrule` =  '#{number}' AND  `dialplan_config`.`dialplan` =  'DID Table' ;"
  end
end