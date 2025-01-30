# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

# require "rvm/capistrano"
# "config/local_env.yml",

set :application, "unite-the-armies-2024"
set :repo_url, "git@github.com:Nerdman4U/unite2024.git"
append :linked_files, "config/credentials.yml.enc", "public/googleca9639854eea1a9b.html", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system"
append :linked_dirs, ".bundle"
set :keep_releases, 5
set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs

namespace :deploy do
  desc "install"
  task :install do
    on roles(:all) do
      within release_path do
        execute "bin/bundle", "install"
        if (fetch(:stage) == :production)
          execute "bin/rails", "deploy:migrate_production"
          execute "bin/rails", "deploy:precompile_production"
          #invoke "passenger:restart"
          # execute "bin/rails", "deploy:restart_production"
        elsif (fetch(:stage) == :staging)
          execute "bin/rails", "deploy:migrate_staging"
          execute "bin/rails", "deploy:precompile_staging"
          #invoke "passenger:restart"
          # execute "bin/rails", "deploy:restart_staging"
        end
      end
    end
  end

  desc "Test and tune capistrano deployment"
  task :tune do
    on roles :all do
      within release_path do
        if (fetch(:stage) == :production)
          execute "echo \"production\""
          invoke "passenger:restart"
        elsif (fetch(:stage) == :staging)
          execute "echo \"staging\""
        end
      end
    end
  end

  desc "Run rails tests"
  task :test do
    on roles :all do
      run_locally do
        execute "bin/rails", "test"
        execute "bin/rails", "test:system"
      end
    end
  end

  desc "Migrate"
  task :migrate do
    on roles :all do
      within release_path do
        execute "bin/rails", "deploy:migrate"
      end
    end
  end
end

before "deploy:starting", "deploy:test"
after "deploy", "deploy:install"
