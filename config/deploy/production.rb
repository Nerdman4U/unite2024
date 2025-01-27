server 'servu', user: 'jto', roles: %w{app db web}
set :deploy_to, '/var/www/unitethearmies.org.2/www'
set :ssh_options, { forward_agent: true }
set :stage, :production
set :rails_env, :production
