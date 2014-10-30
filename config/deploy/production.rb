# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.


role :app, %w{192.168.0.1}
role :web, %w{192.168.0.1}
role :db,  %w{192.168.0.1}

set :default_env, {'PATH' => '/usr/local/bin:/usr/bin:/bin:/usr/games:/usr/lib64/java/bin:/usr/lib64/qt/bin:/opt/ruby/bin'}
ruby_path = "PATH=/opt/ruby/bin:$PATH"

server '192.168.0.1', roles: %w{web app}, ssh_options: {user: 'evomedia', port: 2222}#, my_property: :my_value

namespace :deploy do
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      #deploy:migrate
      #execute "#{ruby_path} && cd #{fetch(:deploy_to)}current/ && RAILS_ENV=production bundle exec rake db:migrate"
      #execute "#{ruby_path} && cd #{fetch(:deploy_to)}current/ && RAILS_ENV=production bundle exec rake assets:precompile"
      execute '/home/evomedia/rc.d/rc.unicorn-evomedia restart'
    end
  end
end

