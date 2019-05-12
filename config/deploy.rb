# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "qna"
set :repo_url, "git@github.com:KhIgorLe/qna.git"
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/qna/qna"
set :deploy_user, 'qna'
set :pty, true
set :sidekiq_queue, %i[default mailers]

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

after 'deploy:finished', 'thinking_sphinx:index'
after 'deploy:finished', 'thinking_sphinx:restart'

after 'deploy:publishing', 'unicorn:restart'
