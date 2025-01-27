server 'servu', user: 'jto', roles: %w{app db web}
set :deploy_to, '/var/www/unitethearmies.org.2/testi'
set :ssh_options, { forward_agent: true }
set :stage, :staging
set :rails_env, :staging
