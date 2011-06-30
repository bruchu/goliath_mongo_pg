require 'postgres-pr/postgres-compat'

import 'http_log'

RAILS_ENV = Goliath.env

config['horoscope_db'] = EventMachine::Synchrony::ConnectionPool.new(:size => 20) do
  conn = EM::Mongo::Connection.new('localhost', 27017, 1, {:reconnect_in => 1})
  conn.db("zambosa_#{ Goliath.env}")
end

# environment(:development) do


#   # for demo purposes, some dummy accounts
#   timebin = ((Time.now.to_i / 3600).floor * 3600)

#   # This user's calls should all go through
#   config['api_auth_db'].collection('AccountInfo').save({
#       :_id => 'i_am_awesome', 'valid' => true,  'max_call_rate' => 1_000_000 })

#   # this user's account is disabled
#   config['api_auth_db'].collection('AccountInfo').save({
#       :_id => 'i_am_lame',    'valid' => false, 'max_call_rate' => 1_000 })

#   # this user has not been seen, but will very quickly hit their limit
#   config['api_auth_db'].collection('AccountInfo').save({
#       :_id => 'i_am_limited', 'valid' => true, 'max_call_rate' =>     10 })

#   # fakes a user with a bunch of calls already made this hour -- two more = no yuo
#   config['api_auth_db'].collection('AccountInfo').save({
#       :_id => 'i_am_busy',    'valid' => true, 'max_call_rate' =>  1_000 })
#   config['api_auth_db'].collection('UsageInfo').save({
#       :_id => "i_am_busy-#{timebin}", 'calls' =>  999 })
# end

filename = File.join(File.dirname(__FILE__), 'config', 'database.yml')
ActiveRecord::Base.configurations = YAML::load(ERB.new(File.read(filename)).result)
#puts ActiveRecord::Base.configurations[Goliath.env.to_s]
ActiveRecord::Base.default_timezone = :utc
ActiveRecord::Base.logger = logger
#ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Goliath.env.to_s])
