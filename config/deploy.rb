# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

#require "rvm/capistrano"

set :application, 'unite-the-armies-2024'
set :repo_url, "git@github.com:Nerdman4U/unite2024.git"
append :linked_files, 'config/credentials.yml.enc','public/googleca9639854eea1a9b.html', 'config/local_env.yml', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system'
append :linked_dirs, '.bundle'
set :keep_releases, 5
set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs
set :stage, :production
set :rails_env, :production

namespace :deploy do
  desc "install"
  task :install do
    on roles(:all) do
      within release_path do
        execute "bin/rails", 'deploy:precompile'
        execute "bin/rails", 'deploy:restart'
      end
    end
  end

  desc "Test"
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
        execute "bin/rails", 'db:migrate'
      end
    end
  end

end

before 'deploy:starting', 'deploy:test'
after 'deploy', 'deploy:install'

# after :restart, :clear_cache do
#   on roles(:web), in: :groups, limit: 3, wait: 10 do
#     # Here we can do anything such as:
#     # within release_path do
#     #   execute :rake, 'cache:clear'
#     # end
#   end
# end


#   desc "Symlink shared config files"
#   task :symlink_bundler do
#     on roles :all do
#       within release_path do
#         execute "rm #{release_path}/vendor/bundle" rescue nil
#         execute "ln -s #{deploy_to}/shared/vendor_bundle #{release_path}/vendor/bundle"
#       end
#     end
#   end

#   desc 'foo'
#   task :foobar do
#     on roles :all do
#     end
#   end

#before 'deploy:foobar', 'rvm:install_rvm'  # install/update RVM
#before 'deploy:foobar', 'rvm:install_ruby' # install Ruby and create gemset, OR:

