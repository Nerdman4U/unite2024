namespace :bundle do
  desc "Install gems"
  task :install do
    system("bin/bundle install")
  end
end

namespace :deploy do
  desc "Precompile assets"
  task :precompile_production do
    system("RAILS_ENV=production bin/rails assets:precompile")
  end
  task :precompile_staging do
    system("RAILS_ENV=staging bin/rails assets:precompile")
  end

  desc "Migrate"
  task :migrate_production do
    system("RAILS_ENV=production bin/rails db:migrate")
  end
  task :migrate_staging do
    system("RAILS_ENV=staging bin/rails db:migrate")
  end

  task :restart do
    system("passenger-config restart-app /var/www/unitethearmies.org/")
  end
end
