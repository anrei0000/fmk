# What's this ?
Command line helpers for working with Laravel on Laradock in Windows.

# Who's this for ?
1. Me. Please keep this in mind.
2. Anyone else who wants to have a one line setup for local Laravel development project and more. And also who has the time to read a bit of code and do some installs.

Using this project you get the benefit of automating the: phpstorm db connection, phpstorm debug
config,  local host name, .env variables setup, laravel file permissions, nginx confix and mysql config.

# Installation steps
## Install `bash_profile`
* Fork my repo
* Add the contents of `/.bash_profile` to your `~/.bash_profile`. Or just replace it entirely if that's what you want.
* Re-open you terminal instance. Or just re-initialise your `~/.bash_profile`.
* Setup the path to your repo folders. Find `fmk-cd-repo` function in `/.bash_profile` and set the correct folder path.

## Install `Laradock` (hopefully you have this already)
* Follow steps [here](https://laradock.io/getting-started/#2-2-installation), project is currently [here](https://github.com/laradock/laradock.git).
* Copy my `laradock` folder over your `/install/path/laradock/` folder, to add all the extra goodies. I don't expect anything to change, all the things should be new additions, please backup your stuff :D

# Usage
### Setup a new project from scratch
Run `fmk-project-laravel myNewProject`

This will do something along the lines of:
* Setup your laradock nginx with the default `laradock/nginx/sites/laravel.conv.example` as a starting point.
* Setup your laradock mysql with the default `laradock/mysql/docker-entrypoint-initdb.d/createdb.sql.example` as a starting point; create a new schema and user.
* Install a new laravel project using `laravel new`; change the default `.env` with credentials, app name, hostname; setup file permissions
* Setup local hosts file by appending a new record in the form `http://myNewProject.local`
* Setup phpstorm: setup the new database connection;
on the first run you need to input the credentials from `.env`; 
setup debug connection for your new project.
* Rebuild laradock machines used for the project.

### New setup for existing laravel project
Run `fmk-project-laravel-existing myExistingProject`

This assumes you installed the project (with `laravel new`) and also setup `.env` and does the remaining steps.
### New setup for existing project (other than laravel) 
Run `fmk-project-existing myExistingNonLaravelProject`

This assumes the base project isn't Laravel then does the remaining steps. 
There is 1 extra step here: 
* Change the nginx config to point to correct entrypoint then rebuild.

### Others
* Shortcuts for ssh-ing into various containers like `fmk-lara-ssh` (workspace), `fmk-lara-ssh-mysql` (mysql), `fmk-lara-ssh-nginx-root` (nginx as root), and others...

Please read the source to find all other functionalities.

### Known errors
* Run `fmk-lara-up` and get

`open \\.\pipe\docker_engine_linux: The system cannot find the file specified.`

This means your Docker didn't start yet. Patience young padawan.

# Contributing
Now THAT would be great! Thanks a bunch!