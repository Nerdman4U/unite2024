server 'servu', user: 'jto', roles: %w{app db web}
set :deploy_to, ENV['UNITE_DEPLOY_PATH_STAGING']
set :ssh_options, { forward_agent: true }
set :stage, :staging
set :rails_env, :staging
