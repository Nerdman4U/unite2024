namespace :bundle do
  desc "Install gems"
  task :install do
    system("bin/bundle install")
  end
end

namespace :deploy do
  desc "Precompile assets"
  task :precompile do
    system("RAILS_ENV=production bin/rails assets:precompile")
  end

  task :restart do
    system("passenger-config restart-app /var/www/unitethearmies.org/")
  end

end


