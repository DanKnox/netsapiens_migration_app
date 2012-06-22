class ActivateConferenceSqlTask < MigrationTask
  ACTIVATE_TABLES = [:conference_update,:gateway_update,:participant_update]
  
  def execute
    ACTIVATE_TABLES.each do |table|
      activate_sql_for @city, table
    end
  end
  
  def activate_sql_for(city,table)
    SSH_CREDENTIALS[city][:model].connection.execute send( table )
  end
  
  def conference_update
    "INSERT INTO NcsDomain.conference_update SELECT '', matchrule, domain, leader, leader_login, leader_pin, speaker_pin, participants_pin, max_participants, time_begin, time_end, gmt_offset, activate, audio_dir, prompt_welcome, announce_join, announce_depart, dial_plan, rate, name, save_participants, request_name, lock_part, annc_part, mute, trigger_by, leader_required, quorum, sip_proxy, sip_auth_user, sip_auth_key, reg_required, 'no', 'pending' FROM NcsDomain.conference_config where domain = '#{@domain}'"
  end
  
  def gateway_update
    "INSERT INTO NcsDomain.gateway_update SELECT '', aor, domain, gw_type, termination_match, uri_scheme, req_user_trans, req_host_trans, to_user_trans, to_host_trans, from_user_trans, from_host_trans, address, origination_allowed, termination_allowed, nat_wan, authenticate_invite, authentication_alg, auth_user, authentication_realm, authentication_key, registration_required, rate, rate_account, rate_max, rate_ratio, rate_margin, max_orig, max_term, max_total, min_orig_prd, min_term_prd, min_dura, name, out_dial_translation, out_dial_delay, out_dial_mode, dial_plan, dial_policy, gmt_offset, time_zone, call_processing_rule, description, 'no','','pending' from NcsDomain.gateway_config where aor like '%#{@domain}%'"
  end
  
  def participant_update
    "INSERT INTO NcsDomain.participant_update SELECT '', participant_match, conference_match, name, pin, leader, '', auto_ans, auto_con, auto_dsc, rcv_only, keep, rate, gain_tx, gain_rx, 'no','','pending' FROM NcsDomain.participant_config where conference_match like '%#{@domain}%'"
  end
  
end