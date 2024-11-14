server 'servu', user: 'jto', roles: %w{app db web}
set :deploy_to, '/var/www/test.unitethearmies.org'
set :ssh_options, { forward_agent: true }
