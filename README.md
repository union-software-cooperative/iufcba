# README

A collective bargaining agreement database for affiliates of The International Union of Food, Agricultural, Hotel, Restaurant, Catering, Tobacco and Allied Workers' Associations (IUF).

## DEPLOYMENT

`git clone git@github.com:union-software-cooperative/iufcba`

cp config/application.example.yml config/application.yml
\# Setup AWS buckets for production and development ( or change to local storage in config/initializers/carrierwave.rb )
\# Configure mailgun ( or change config.action_mailer.delivery_method in config/environments/... )
\# Generate secret keys for secpubsub and rails application
\# change the name of the owner union

\# change the db/seeds.rb file - the first union's short_name must match the owner union name from application.yml

`bundle install`
`bundle exec rake db:create`
`bundle exec rake db:migrate`
`bundle exec rake db:seed`

\# to deploy on heroku
`heroku apps:create my_unique_app_name`
\# you may have to add the heroku remote
`figaro heroku:set -e production`
`git push heroku master`
`heroku run rake db:migrate`
`heroku run rake db:seed`
`heroku domains:add www.iufcba.org`
\# restart after seed so owner union works
`heroku restart`

