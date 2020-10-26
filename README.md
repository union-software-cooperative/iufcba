# docker-ruby-template

This project sets up a ruby development environment with a postgresql database.   Bundle install and migrating the database is left to docker runtime (via a script in app/start.docker) rather than at build time (which is a pain because everytime your gemfile changes it has to install all gems from scratch).  

Check the app.dockerfile which has several ruby configs to choose from.  Only basic ruby is uncommented.

Also check the app/docker-start.  It also only has basic ruby startup uncommented, with some rails examples commented out.

```
git clone git@github.com:union-software-cooperative/docker-ruby-template.git your-project-name
```

## Setup git for your new project

unlink the docker-ruby-template repo
```
cd your-project-name
rm -rf .git
```

make a new repo on github

```
git init
git remote add origin your-git-repo
git add .
git commit -m "Initial commit."
git push origin master
```

## basic docker usage
run containers (daemonised)
```
docker-compose up -d
```

see logs
```
docker-compose logs
```

Shell into the ruby app container
```
docker-compose exec app /bin/bash
```

## Using docker-compose shortcuts
typing docker-compose all the time can be tedious so add this to your ~/.bashrc or ~/.bash_profile

Then 

`docker-compose stop && docker-compose up -d && docker-compose log -tf` 

becomes just

`dcs && dcu -d && dcl -tf`

but i have a shortcut for that

`dcrestart`

The first alias makes editing and reloading your bash_profile easy.

The second command `get-ruby` makes getting this repo easy.

```
# shortcut for editing your bash profile and these shortcuts
alias bp='vim ~/.bash_profile && . ~/.bash_profile'
# Get this repo!
get-ruby() { git clone git@github.com:union-software-cooperative/docker-ruby-template.git . ; rm -rf .git ; }
# docker shortcuts
alias ds='docker stats'
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcr='docker-compose run'
alias dcs='docker-compose stop'
alias dcb='docker-compose build'
alias dcps='docker-compose ps'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f --tail=1000'
alias dckill='docker-compose kill'
alias dcrestart='docker-compose stop && docker-compose up -d && docker-compose logs -ft'
alias dps='docker ps'
alias dk='docker kill'
alias dkall='docker kill $(docker ps -q)'
alias drestart="osascript -e 'quit app \"Docker\"' && open -a Docker"
alias dstop='docker stop $(docker ps -aq)'
alias dprune='docker system prune -a'
dceb() { docker-compose exec $1 /bin/bash ; }
dcub() { docker-compose up -d $1 && docker-compose exec $1 /bin/bash ; }
dcudb() { docker-compose up -d db && docker-compose exec db psql -U postgres $1 ; }
ddeleteall() {
    docker stop $(docker ps -aq)
    docker system prune -a
}
```

## Persisting data
Mount your pgdata and bundle data on an external docker volume, so if you rebuild or remove your db or www containers you don't loose all your data and don't have to reinstall all your gems.  I also persist root, to preserve command history etc...  This is done by default in the docker-compose.yaml file.

## developing with docker on osx
On osx docker volume mounts to the host are suuupperrr slow.

mount your app volume like this in the override file
```
cp docker-compose.override.yml.example docker-compose.override.yml
```

```
  app:
    volumes:
      - ./app:/app:delegated
```

The example override file will not actually run your app.  Instead it runs an override command that hangs the container to leave it running so you can shell in and run your application yourself.  This makes debugging easy.  

The short cut for running your app then shelling in is
`dcub app` 

Once shelled in you can run `ruby start` or `rails s -b 0.0.0.0` etc...

## Using compose and the override file in production 
If running more than one compose app on a production server, you'll want to have your port mappings in the override.  For instance, it is common to clash on postgres' port 5431 unless you override this port for each app. 

If you are running multiple compose apps that use each other's api's (think microservices) but don't want to expose those service publicly, configure an external docker network.  `docker network add my-production-net`  

