namespace :deploy do
  desc "Install gems and precompile assets"
  task :install do
    system("bundle install")
    system("RAILS_ENV=production bin/rails assets:precompile")
    system("passenger-config restart-app /var/www/unitethearmies.org/")
  end
end
