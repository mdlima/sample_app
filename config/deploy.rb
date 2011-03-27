require "bundler/capistrano"

# ==============================================================
# SET's
# ==============================================================

default_run_options[:pty] = true 

set :user, "boscolotshirt"
set :domain, "boscolotshirt.com.br"
set :application, "sample_app"
# set :db_name, "boscolotshirt2"

set :local_repository,  "ssh://#{user}@#{domain}/~/repo/#{application}.git"
set :repository,  "file:///home/#{user}/repo/#{application}.git"
set :scm, "git"
# set :scm_passphrase, "senha"
# set :scm_user, "usuario"
 
set :use_sudo, false  #railsplayground nao aceita sudo
set :branch, "master" #branch que sera copiado
set :deploy_to, "/home/#{user}/rails_projects/#{application}"  #pasta para onde serao enviados os arquivos
# set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :remote, user
set :scm_verbose, true
set :copy_cache, true 
set :keep_releases, 3 # mantem 3 versoes, posso fazer ate 3 rollbacks de versao

set :build_nokogiri, "--with-xslt-dir=/home/storage/c/9a/91/boscolotshirt/local --with-xml2-include=/home/storage/c/9a/91/boscolotshirt/local/include/libxml2 --with-xml2-lib=/home/storage/c/9a/91/boscolotshirt/local/lib"

# ==============================================================
# ROLE's
# ==============================================================

server domain, :app, :web, :db, :primary => true


# ==============================================================
# TASK's
# ==============================================================
 
after "deploy:update_code", :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
end


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

