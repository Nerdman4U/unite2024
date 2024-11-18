namespace :deploy do
  desc "Install gems and precompile assets"
  task :install do
    system("bundle install")
    system("RAILS_ENV=production bin/rails assets:precompile")
  end

  desc "Testing"
  task :name do
    system("whoami")
  end
end
