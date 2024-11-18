namespace :deploy do
  desc "Install gems"
  task :install_gems do
    on roles(:all) do
      within release_path do
        execute :bundle, 'install'
      end
    end
  end

  desc "Precompile assets"
  task :precompile_assets do
    on roles(:all) do
      within release_path do
        execute "RAILS_ENV=production bin/rails assets:precompile"
      end
    end
  end
end
