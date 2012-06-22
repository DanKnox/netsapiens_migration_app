class SanDiegoDatabase < ActiveRecord::Base
  establish_connection :sanvthdb
  set_table_name 'domains_config'
end