rvm1cap3
========
This is simple ruby app with one model and his migration. The purpose of the repo is to guide you through process of integration <a href="https://github.com/capistrano/capistrano">capistrano3</a> and setup multi staging deploy on server with <a href="http://rvm.io/">rvm</a>.
There are two deployment servers production (use ruby env) and staging (use rvm)

## passwordless login ##
This setup requires passwordless login from your dev machine to the remote machine and also that the server have passwordless read access to your git repo

One way to accomplish that is with private key and ssh key forwarding. More info:

https://help.github.com/articles/generating-ssh-keys

https://developer.github.com/guides/using-ssh-agent-forwarding/

## required gems ##

<a href="https://github.com/capistrano/capistrano">capistrano3</a>  is used for actual deployment

<a href="https://github.com/capistrano/rails">capistrano-rails</a> is used for rails specific task like run `rake db:migrate` and `rake assets:precompile`

<a href="https://github.com/rvm/rvm1-capistrano3">rvm1-capistrano3</a> is used for detection of ruby binary on the remote machine (where we want to deploy) 

Add these to your Gemfile and install them
```
gem 'capistrano', '~> 3.2.0'
gem 'capistrano-rails', '~> 1.1'
gem 'rvm1-capistrano3', require: false
```
## settings ##

### capistrano ###
init capistrano

`bundle exec cap install`

init stages in our case production and staging

`bundle exec cap install STAGES=staging,production`

### capistrano-rails ###

add this to  your Capefile
```
require 'capistrano/rails'
```
### rvm1-capistrano3 ###

rvm1-capistrano3 are required to deploy only to the rvm server, add this to your Capefile
```
# Use rmv only for stageing 
task :use_rvm do
  require 'rvm1/capistrano3'
end

task 'staging' => [:use_rvm]
```
### deploy configs ###
in config/deploy.rb specify application name and path to the git repository
```
set :application, 'rvm1cap3'
set :repo_url, 'git@github.com:vkdimitrov/rvm1cap3.git'
```
in config/deploy/<stagin.rb, production.rb>

You have to specify ruby version you want to use 
```
set :rvm1_ruby_version, "2.1.1"
```
Tell the capistrano where to deploy 
```
set :deploy_to, '/home/evomedia/rvm1cap3'
```
Fill your remote machine user and ip
```
role :app, %w{evomedia@192.168.0.202}
```
If you want to compile assets and run migrations on deployment server you HAVE to assing :web and :db roles and capistrano-rails will do the work for you
```
role :web, %w{evomedia@192.168.0.202}
role :db, %w{evomedia@192.168.0.202}
```
## actual deploy ##

deploy to production

`cap production deploy`

deploy to staging

`cap staging deploy`
