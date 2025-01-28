server 'servu', user: 'jto', roles: %w{app db web}
set :deploy_to, ENV['UNITE_DEPLOY_PATH_PRODUCTION']
set :ssh_options, { forward_agent: true }
set :stage, :production
set :rails_env, :production
