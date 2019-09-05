rm /usr/src/app/tmp/pids/server.pid

touch log/production.log
chmod 0664 log/production.log

export RAILS_ENV=production
bundle exec rails server -b 0.0.0.0 -p 3002
