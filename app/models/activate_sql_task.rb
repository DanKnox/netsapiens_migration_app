class ActivateSqlTask < MigrationTask
  ACTIVATE_TABLES = [:domains_update,:subscriber_update,:registrar_update,:feature_update,:dialplan_update,:dialplan_update_for_domain,:dial_policy_update]
  
  def execute
    ACTIVATE_TABLES.each do |table|
      activate_sql_for @city, table
    end
  end
  
  def activate_sql_for(city,table)
    SSH_CREDENTIALS[city][:model].connection.execute send( table )
  end
  
  def domains_update
    "INSERT INTO domains_update SELECT '',domain,territory,dial_match,description,moh,mor,mot,rmoh,rating,resi,mksdir,call_limit,sub_limit,time_zone,dial_plan,dial_policy,policies,email_sender,from_user,from_host,'no','pending' FROM domains_config WHERE domain='#{@domain}'"
  end
  
  def subscriber_update
    "INSERT INTO subscriber_update SELECT '',directory_match,aor_scheme,aor_user,aor_host,admin_vmail,accept,reject,do_not_disturb,screen,forward,fwd_not_reg,simultaneous_ring, forward_busy,forward_no_answer,fwd_on_active,no_answer_timeout,firstname,lastname,subscriber_group,subscriber_login,subscriber_pin,language,rate,rating_required,data_limit
    ,call_limit,gmt_offset,time_zone,directory_listing,directory_order,greeting_index,vmail,rcv_broadcast,vmail_say_time,vmail_say_cid,vmail_sort_lifo,email_vmail,email_address,
    dial_plan,dial_policy,callid_nmbr,callid_name,callid_emgr,area_code,domain_dir,srv_code,'no','pending' FROM subscriber_config WHERE aor_host='#{@domain}'"
  end
  
  def registrar_update
    "INSERT INTO registrar_update SELECT '',aor,termination_match,received_from,term_scheme,term_user_trans,contact,nat_wan,expires,registration_required,origination_allowed,termination_allowed, authenticate_register,authenticate_invite,authentication_alg,authentication_realm,authentication_key,rate,subscriber_name,subscriber_domain,dial_plan, dial_policy,call_processing_rule,watch,srv_code,'no','no','pending' FROM registrar_config WHERE subscriber_domain='#{@domain}'"
  end
  
  def feature_update
    "INSERT INTO feature_update SELECT '',name,control,callee_match,caller_match,time_frame,day_match,hour_match,tod_from,tod_to,parameters,activation,expires,'no','','pending' FROM feature_config WHERE callee_match LIKE '%#{@domain}'"
  end
  
  def dialplan_update
    "INSERT INTO dialplan_update SELECT '',matchrule,match_from,dow,tod_from,tod_to,valid_from,valid_to,responder,parameter,to_scheme,to_user,to_host,from_name,from_scheme,from_user,from_host,dialplan,domain,plan_description,'no','pending' FROM dialplan_config WHERE dialplan='DID Table' and to_host = '#{@domain}'"
  end
  
  def dialplan_update_for_domain
    "INSERT INTO dialplan_update SELECT '',matchrule,match_from,dow,tod_from,tod_to,valid_from,valid_to,responder,parameter,to_scheme,to_user,to_host,from_name,from_scheme,from_user,from_host,dialplan,domain,plan_description,'no','pending' FROM dialplan_config WHERE dialplan='#{@domain}'"
  end
  
  def dial_policy_update
    "INSERT INTO dial_policy_update SELECT '',name,domain,dial_match,mode,reason, 'no','','pending' FROM dial_policy_config WHERE domain = '#{@domain}'"
  end
end
