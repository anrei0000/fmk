###############################
### Start docker related ######
###############################

# shortcut for docker compose
function dc(){
	docker-compose $@
}

# cleanup old docker images
function dcleanup(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

# Run shell into a container
function fmk-docker-ssh(){
	winpty docker exec -it $@ "//bin/sh"
}

# Run composer install in the current dir
function fmk-composer-i(){
	winpty docker run --rm --interactive --tty --volume='$PWD:/app' composer install
}

# Turn on laradock machines
function fmk-lara-up(){
	fmk-cd-laradock && docker-compose up -d nginx mysql redis phpmyadmin workspace solr
}

# Rebuild laradock machines
function fmk-lara-rebuild(){
	fmk-cd-laradock && docker-compose down && docker-compose build nginx mysql redis php-fpm phpmyadmin workspace solr && fmk-lara-up
}

# Turn on laradock machine for apache webserver
function fmk-lara-up-apache(){
	fmk-cd-laradock && docker-compose up -d apache2 mysql redis phpmyadmin workspace solr
}

# Rebuild laradock machines for apache webserver
function fmk-lara-rebuild-apache(){
	fmk-cd-laradock && docker-compose down && docker-compose build apache2 mysql redis php-fpm phpmyadmin workspace solr && fmk-lara-up-apache
}

# Enter laradock workspace
# Example 1: `fmk-lara-ssh` will ssh into workspace as default user
# Example 2: `fmk-lara-ssh ls` will send the `ls` command over ssh to workspace and output results localy
function fmk-lara-ssh() {
	command="$@"
	# pass arguments to remote ssh
	if [ -z "$@" ]
	then
		fmk-cd-laradock && winpty docker-compose exec --user=laradock workspace bash
	else
		fmk-cd-laradock && winpty docker-compose exec --user=laradock workspace bash -itc "$@"
	fi
}

# Enter laradock workspace as root
# Example 1: `fmk-lara-ssh-root` will ssh into workspace as root user
# Example 2: `fmk-lara-ssh-root ls` will send the `ls` command over ssh to workspace as root and output results localy
function fmk-lara-ssh-root(){
	command="$@"
    if [ -z "$@" ]
	then
		fmk-cd-laradock && winpty docker-compose exec --user=root workspace bash
	else
		fmk-cd-laradock && winpty docker-compose exec --user=root workspace bash -itc "$@"
	fi
}

# Enter laradock php-fpm container as default user
function fmk-lara-ssh-php(){
	fmk-cd-laradock && winpty docker-compose exec php-fpm bash
}

# Enter laradock nginx container as default user
function fmk-lara-ssh-nginx(){
	fmk-cd-laradock && winpty docker-compose exec nginx bash
}


# Enter laradock nginx container as root user
function fmk-lara-ssh-nginx-root(){
        fmk-cd-laradock && winpty docker-compose exec --user=root nginx bash
}

# Enter laradock solr container as default user
function fmk-lara-ssh-solr(){
	fmk-cd-laradock && winpty docker-compose exec solr bash
}

# Enter laradock solr container as root user
function fmk-lara-ssh-solr-root(){
	fmk-cd-laradock && winpty docker-compose exec --user=root solr bash
}

# Enter mysql container
# Example 1: `fmk-lara-ssh-mysql` will ssh into the mysql container
# Example 2: `fmk-lara-ssh-mysql ls` will ssh into the mysql container then output the result for `ls`
function fmk-lara-ssh-mysql() {
	command="$@"
	# pass arguments to remote ssh
	if [ -z "$@" ]
	then
		fmk-cd-laradock && winpty docker-compose exec mysql bash
	else
		fmk-cd-laradock && winpty docker-compose exec mysql bash -itc "$@"
	fi
}

# Enter laradock apache2 container
# Example 1: `fmk-lara-ssh-apache2` will ssh into the apache2 container
# Example 2: `fmk-lara-ssh-apache2 ls` will ssh into the apache2 container then output the result for `ls`
function fmk-lara-ssh-apache2() {
	command="$@"
	# pass arguments to remote ssh
	if [ -z "$@" ]
	then
		fmk-cd-laradock && winpty docker-compose exec apache2 bash
	else
		fmk-cd-laradock && winpty docker-compose exec apache2 bash -itc "$@"
	fi
}

# Run the go build command
function fmk-go-build(){
	winpty docker run -it -p 8080:8080 --volume='//c//repo//golang:/go/src/github.com/user/myProject' 7ced090ee82e
}

# Go to laradock project
# This is used on the host machine
function fmk-cd-laradock(){
	fmk-cd-repo && cd laradock
}

# Go to repo project
# This is used on the host machine, this is the folder where your repos live
# For example if your local path is `/c/projects/dummyProject/index.php` then
# set this function to `cd /c/projects`
function fmk-cd-repo(){
	cd /c/repo
}

# Copy file from prod to local
function fmk-prod-cp(){
	scp -i /c/repo/credentials/aws.me/ciuc-web.pem -r ubuntu@ec2-52-11-99-13.us-west-2.compute.amazonaws.com:$0 $1
}


###############################
### End docker related ########
###############################

###############################
## Start do nothing functions #
###############################

# Do nothing laradock new project
function fmk-dn-newlaravel(){
	# Nginx
	echo -e "\n # Setup nginx \n"
	echo -e "- Duplicate file.conf \n"
	echo -e "- Set server name \n"
	echo -e "- Set root location \n"
	echo -e "- Set logs locations \n"
	read -n 1 -s -r -p "Press any key to continue..."

	# MySQL
	echo -e "\n # Setup MySQL \n"
	echo -e "- Duplicate file.sql \n"
	echo -e "- Set db name \n"
	echo -e "- Set user name \n"
	echo -e "- Set grants \n"
	read -n 1 -s -r -p "Press any key to continue..."

	# Rebuild containers
	echo -e "\n # Rebuild Laradock containers \n"
	echo -e "- Run fmk-lara-rebuild \n"
	read -n 1 -s -r -p "Press any key to continue..."

	# Windows hosts edit
	echo -e "\n # Edit windows hosts file \n"
	echo -e "- Add 127.0.0.1 project.local in the hosts file \n"
	read -n 1 -s -r -p "Press any key to continue..."

	# IDE config
	echo -e "\n # IDE config \n"
	echo -e "- Open project in PHPStorm \n"
	echo -e "- Configure MySQL connection in PHPStorm \n"
	echo -e "- Configure debug in PHPStorm \n"
	read -n 1 -s -r -p "Press any key to continue..."

	# Setup git repo
	echo -e "\n # Git config \n"
	echo -e "- Create a new repo to track the project \n"
	echo -e "- git init \n"
	echo -e "- git remote add origin  git@bitbucket.org:anrei0000/project.git \n"
	echo -e "- git add -A \n"
	echo -e "- git commit -m "- initial commit" \n"
	echo -e "- git push -u origin master \n"
	read -n 1 -s -r -p "Press any key to continue..."

	# Test everything works
	echo -e "\n # Test project loads \n"
	echo -e "- open project.local in browser \n"
	read -n 1 -s -r -p "Press any key to continue..."

}

###############################
## End do nothing functions ###
###############################

###############################
### Start Git   ###############
###############################

# Add an upstream to the current git repo
function fmk-git-remote-add(){
	git remote add upstream $@
}

# Update your locally forked project with the upstream
# The command uses your param as branch to update
# OR defaults to master when no input is sent
function fmk-git-upstream-update(){
	branch="$1"

	# if no project was set
	if [ -z "$branch" ]
	then
      		branch="master"
	fi

	git checkout $branch
	git fetch --all
	git merge upstream/$branch
}

# Update your locally forked project with the upstream
# The command uses your param as branch to update
# OR defaults to master when no input is sent
function fmk-git-remote-update-from-tag(){
	tag="$1"

	# if no tag was set
	if [ -z "$tag" ]
	then
		echo "Please input which tag you want to merge!"
      		return -1;
	fi

	# Optional information:
	# git branch -a 		# show all remote and local branches
	# git remote show origin	# show all remote branches in origin
	# git ls-remote --tags origin	# show all remote tags in origin

	git fetch --all --tags
	git checkout master
	git merge tags/$tag

	echo "Merge done, do you want to push ?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) git push; return -1; break;;
			No ) return -1;;
		esac
	done

}

# Backup the .bash_profile file
function fmk-backup-home(){
	cp ~/.bash_profile ~/.bash_profile_bk
	cp ~/.bash_profile /c/repo/windows
	cd /c/repo/windows
	git add -A
	git commit -m "- script update .bash_profile"
	git push
}


###############################
### End Git    ################
###############################


###############################
### Start Other ###############
###############################

# Find listening port
function fmk-port(){
	netstat -ano | findstr :$@
}

# Create the nginx conf file
#
# projectName: can be set to something like "test"
# pathToLaradock: should be set to something like "/c/repo/laradock"
function fmk-project-nginx(){
	projectName="$1"
	pathToLaradock="$2"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToLaradock" ]
	then
		echo "Please set the path to Laradock!";
		return -1;
	fi

	cd $pathToLaradock/nginx/sites
	if [ -f "$projectName.local.conf" ]
	then
	    echo "Path to $pathToLaradock/nginx/sites/$projectName.local.conf already exists!"
	    return -1;
	else
		cp laravel.conf.example $projectName.local.conf
		sed -i "s/laravel/$projectName/g" $projectName.local.conf
	    echo "Created $pathToLaradock/nginx/sites/$projectName.local.conf..."
	fi
}

# Create the mysql conf file
#
# projectName: can be set to something like "test"
# pathToLaradock: should be set to something like "/c/repo/laradock"
function fmk-project-mysql(){
	projectName="$1"
	pathToLaradock="$2"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToLaradock" ]
	then
		echo "Please set the path to Laradock!";
		return -1;
	fi

	# Create MySQL
	cd $pathToLaradock/mysql/docker-entrypoint-initdb.d

	if [ -f "createdb-$projectName.sql" ]
	then
	    echo "Path to $pathToLaradock/mysql/docker-entrypoint-initdb.d/createdb-$projectName.sql already exists!"
	    return -1;
	else
		cp createdb.sql.example createdb-$projectName.sql
		sed -i "s/example/$projectName/g" createdb-$projectName.sql
	 	echo "Created $pathToLaradock/mysql/docker-entrypoint-initdb.d/createdb-$projectName.sql..."

	 	fmk-lara-ssh-mysql "mysql -u root -proot < /docker-entrypoint-initdb.d/createdb-$projectName.sql"
	fi

	# Prepare destroy MySQL script
	cd $pathToLaradock/mysql/docker-entrypoint-initdb.d

	if [ -f "dropdb-$projectName.sql.noautorun" ]
	then
	    echo "Path to $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun already exists!"
	    return -1;
	else
		cp dropdb.sql.example dropdb-$projectName.sql.noautorun
		sed -i "s/example/$projectName/g" dropdb-$projectName.sql.noautorun
	 	echo "Created $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun..."
	fi

 	echo "Updated mysql config..."
}


# Install the Laravel project
#
# projectName: can be set to something like "test"
# pathToRoot: should be set to something like "/c/repo"
function fmk-project-laravel(){
	projectName="$1"
	pathToRoot="$2"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToRoot" ]
	then
		echo "Please set the path to root!";
		return -1;
	fi
	# Setup Laravel project
	fmk-lara-ssh "laravel new $projectName"
	echo "Installed Laravel..."
	fmk-project-laravel-env $projectName $pathToRoot
	fmk-project-laravel-files $projectName $pathToRoot
}


# Update the env conf file
#
# projectName: can be set to something like "test"
# pathToRoot: should be set to something like "/c/repo"
function fmk-project-laravel-env(){
	projectName="$1"
	pathToRoot="$2"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToRoot" ]
	then
		echo "Please set the path to root!";
		return -1;
	fi

	# Configure .env
	cd $pathToRoot

	fmk-lara-ssh "cd /var/www/$projectName && cp .env.example .env && php artisan key:generate"


	if [ -f "$pathToRoot/$projectName/.env" ]
	then
    	sed -i "s+APP_NAME=Laravel+APP_NAME=$projectName+g" $pathToRoot/$projectName/.env
    	sed -i "s+APP_URL=http://localhost+APP_URL=http://$projectName.local+g" $pathToRoot/$projectName/.env
    	sed -i "s+DB_HOST=127.0.0.1+DB_HOST=mysql+g" $pathToRoot/$projectName/.env
    	sed -i "s+DB_DATABASE=laravel+DB_DATABASE=$projectName+g" $pathToRoot/$projectName/.env
    	sed -i "s+DB_USERNAME=root+DB_USERNAME=$projectName+g" $pathToRoot/$projectName/.env
    	sed -i "s+DB_PASSWORD=+DB_PASSWORD=secret+g" $pathToRoot/$projectName/.env
 		echo "Configured $pathToRoot/$projectName/.env..."
	else
	    echo "Problem configuring $pathToRoot/$projectName/.env!"
	    return -1;
	fi
}


# Install the Laravel project's file permissions
#
# projectName: can be set to something like "test"
# pathToRoot: should be set to something like "/c/repo"
fmk-project-laravel-files(){
	projectName="$1"
	pathToRoot="$2"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToRoot" ]
	then
		echo "Please set the path to root!";
		return -1;
	fi

	fmk-lara-ssh-root "cd \"/var/www/$projectName\" && chown -R www-data: . && find . -type f -exec chmod 664 {} \; && find . -type d -exec chmod 775 {} \;"

	echo "Installed Laravel file permissions..."
}

# Update the Windows hosts file
#
# projectName: can be set to something like "test"
# pathToRoot: should be set to something like "/c/repo"
fmk-project-hosts(){
	projectName="$1"
	pathToRoot="$2"
	pathToHosts="/c/Windows/System32/drivers/etc/hosts"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToRoot" ]
	then
		echo "Please set the path to root!";
		return -1;
	fi

	# Windows hosts edit
	cp $pathToHosts "$pathToRoot/$projectName/hosts"
	sed -ie "\$a127.0.0.1 $projectName.local" "$pathToRoot/$projectName/hosts"
	cp "$pathToRoot/$projectName/hosts" $pathToHosts
	rm -rf "$pathToRoot/$projectName/hosts"
	rm -rf "$pathToRoot/$projectName/hostse"
	echo "Updated Windows hosts file...";
}

# Create a new PhpStorm configuration with debug and mysql
# connection (which will need you to insert credentials)
#
# projectName: can be set to something like "test"
# pathToRoot: should be set to something like "/c/repo"
# pathToLaradock: should be set to something like "/c/repo/Laradock"
#
# Usage: first time you use the mysql connection, set your credentials to
# match your `.env` and also store them in PhpStorm forever &ever
function fmk-project-phpstorm(){
	projectName="$1"
	pathToRoot="$2"
	pathToLaradock="$3"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	if [ -z "$pathToRoot" ]
	then
		echo "Please set the path to root!";
		return -1;
	fi

	if [ -z "$pathToLaradock" ]
	then
		echo "Please set the path to Laradock!";
		return -1;
	fi

	if [ -d "$pathToRoot/$projectName/.idea" ]
	then
		echo "Path to $pathToRoot/$projectName/.idea already exists!";
		return -1;
	else
		mkdir "$pathToRoot/$projectName/.idea"
	fi

	# Create PhpStorm configuration for debug
	pathToWorkspace="$pathToRoot/$projectName/.idea/workspace.xml"
	pathToExampleWorkspace="$pathToLaradock/intellij/workspace.example.xml"
	cp $pathToExampleWorkspace $pathToWorkspace
	sed -i "s/example/$projectName/g" $pathToWorkspace
	echo "Updated PhpStorm configuration for debug...";

	# Create PhpStorm configuration for database
	pathToDataSources="$pathToRoot/$projectName/.idea/dataSources.xml"
	pathToExampleDataSources="$pathToLaradock/intellij/dataSources.example.xml"
	cp $pathToExampleDataSources $pathToDataSources
	sed -i "s/example/$projectName/g" $pathToDataSources
	echo "Updated PhpStorm configuration for database...";

	# Add .idea to .gitignore file
	echo "/.idea" >> $pathToRoot/$projectName/.gitignore
	echo "Updated .gitignore configuration for PhpStorm...";
}


# Create a new application for local dev using
# Laravel, Laradock (Nginx, MySQL), Windows hosts
#
# projectName: can be set to something like "test"
function fmk-project(){
	projectName="$1"
	pathToRoot="/c/repo"
	pathToLaradock="$pathToRoot/laradock"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	# Config all the stuff
	fmk-project-nginx $projectName $pathToLaradock
	fmk-project-mysql $projectName $pathToLaradock
	fmk-project-laravel $projectName $pathToRoot
	fmk-project-hosts $projectName $pathToRoot

	# EX: fmk-project-phpstorm voyager /c/repo /c/repo/laradock
	fmk-project-phpstorm $projectName $pathToRoot $pathToLaradock

	# Rebuild containers
	fmk-lara-rebuild

	# IDE config debug
	# IDE config mysql
	# Setup git repo
	# Test everything works

	echo "Finished setting up $projectName. Access it locally at: http://$projectName.local";
}

# Create a new application for local dev using
# Laravel, Laradock (Nginx, MySQL), Windows hosts
#
# projectName: can be set to something like "test"
function fmk-project-existing(){
	projectName="$1"
	pathToRoot="/c/repo"
	pathToLaradock="$pathToRoot/laradock"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	# Config all the stuff
	fmk-project-nginx $projectName $pathToLaradock
	fmk-project-mysql $projectName $pathToLaradock
	fmk-project-hosts $projectName $pathToRoot
	fmk-project-phpstorm $projectName $pathToRoot $pathToLaradock

	# Rebuild containers
	fmk-lara-rebuild

	# IDE config debug
	# IDE config mysql
	# Setup git repo
	# Test everything works

	echo "Finished setting up $projectName. Access it locally at: http://$projectName.local";
}


# Create a new application for local dev using
# Laravel, Laradock (Nginx, MySQL), Windows hosts
#
# projectName: can be set to something like "test"
function fmk-project-laravel-existing(){
	projectName="$1"
	pathToRoot="/c/repo"
	pathToLaradock="$pathToRoot/laradock"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	# Config all the stuff
	fmk-project-nginx $projectName $pathToLaradock
	fmk-project-mysql $projectName $pathToLaradock
	fmk-project-laravel-env $projectName $pathToRoot
	fmk-project-laravel-files $projectName $pathToRoot
	fmk-project-hosts $projectName $pathToRoot

	# EX: fmk-project-phpstorm voyager /c/repo /c/repo/laradock
	fmk-project-phpstorm $projectName $pathToRoot $pathToLaradock

	# Rebuild containers
	fmk-lara-rebuild

	# IDE config debug
	# IDE config mysql
	# Setup git repo
	# Test everything works

	echo "Finished setting up $projectName. Access it locally at: http://$projectName.local";
}

# Cleanup after a local dev project is no longer needed
# Laravel, Laradock (Nginx)
# TODO: MySQL container data, Windows hosts entry
#
# projectName: can be set to something like "test"
function fmk-project-cleanup(){
	projectName="$1"
	projectRoot="/c/repo"
	pathToLaradock="$projectRoot/laradock"

	if [ -z "$projectName" ]
	then
		echo "Please set the project name attribute!";
		return -1;
	fi

	echo "Are you sure you want to uninstall $projectRoot/$projectName? "
	read -p "Press [Yy] to continue or any key to quit..." -n 1 -r
	echo    # (optional) move to a new line

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		# Remove project files
	    if [ -d "$projectRoot/$projectName" ]
		then
			rm -rf $projectRoot/$projectName
			echo "Removed $projectRoot/$projectName..."
		else
			echo "The path $projectRoot/$projectName doesn't exist!"
		fi

		# Remove laradock nginx configs
		if [ -f "$pathToLaradock/nginx/sites/$projectName.local.conf" ]
		then
			rm -rf $pathToLaradock/nginx/sites/$projectName.local.conf
			echo "Removed $pathToLaradock/nginx/sites/$projectName.local.conf..."
		else
			echo "The path $pathToLaradock/nginx/sites/$projectName.local.conf doesn't exist!"
		fi

		# Remove laradock mysql data
		cd $pathToLaradock/mysql/docker-entrypoint-initdb.d
		if [ -f "dropdb-$projectName.sql.noautorun" ]
		then
		 	fmk-lara-ssh-mysql "mysql -u root -proot < /docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun"
		 	echo "Ran $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun..."
		else
		    echo "The path $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun doesn't exist!"
		fi

		# Remove laradock mysql configs
		if [ -f "$pathToLaradock/mysql/docker-entrypoint-initdb.d/createdb-$projectName.sql" ]
		then
			rm -rf $pathToLaradock/mysql/docker-entrypoint-initdb.d/createdb-$projectName.sql
			echo "Removed $pathToLaradock/mysql/docker-entrypoint-initdb.d/createdb-$projectName.sql..."
		else
			echo "The path $pathToLaradock/mysql/docker-entrypoint-initdb.d/createdb-$projectName.sql doesn't exist!"
		fi
		if [ -f "$pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun" ]
		then
			rm -rf $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun
			echo "Removed $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun..."
		else
			echo "The path $pathToLaradock/mysql/docker-entrypoint-initdb.d/dropdb-$projectName.sql.noautorun doesn't exist!"
		fi

		# TODO Remove hosts data
    else
    	return -1;
	fi


}

# Change php version
function fmk-version-php(){
	version="$@"
	if [ -z "$version" ]
	then
		echo "Please set the PHP version to change to!";
		return -1;
	fi
	# echo 'changing Php Version to '$version;
	# fmk-cd-laradock
	# sed -i "s+PHP_VERSION=/PHP_VERSION=$version/g" '.env'

	# dc build php-fpm workspace
	# dc down
	# fmk-lara-up
}

# Use aws-cli to detect dominant language in input text
function fmk-aws-language(){
	search="$@"
	if [ -z "$search" ]
	then
		echo "Please set the text to search!";
		return -1;
	fi
	docker run --rm -t $(winpty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "//c//repo//aws-cli:/project" mesosphere/aws-cli comprehend detect-dominant-language --region eu-central-1 --text "$search"

}

# Use aws-cli to detect entities in input text
function fmk-aws-entity(){
	search="$@"
	if [ -z "$search" ]
	then
		echo "Please set the text to search!";
		return -1;
	fi
	docker run --rm -t $(winpty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "//c//repo//aws-cli:/project" mesosphere/aws-cli comprehend detect-entities --region eu-central-1 --language-code "en" --text "$search"

}

# Use aws-cli to detect key phrases in input text
function fmk-aws-key-phrases(){
	search="$@"
	if [ -z "$search" ]
	then
		echo "Please set the text to search!";
		return -1;
	fi
	docker run --rm -t $(winpty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "//c//repo//aws-cli:/project" mesosphere/aws-cli comprehend detect-key-phrases --region eu-central-1 --language-code "en" --text "$search"

}

# Use aws-cli to detect sentiment in input text
function fmk-aws-sentiment(){
	search="$@"
	if [ -z "$search" ]
	then
		echo "Please set the text to search!";
		return -1;
	fi
	docker run --rm -t $(winpty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "//c//repo//aws-cli:/project" mesosphere/aws-cli comprehend detect-sentiment --region eu-central-1 --language-code "en" --text "$search"

}

# Wrapper for aws-cli functions running in sequence
function fmk-aws-comprehend(){
	search="$@"
	if [ -z "$search" ]
	then
		echo "Please set the text to search!";
		return -1;
	fi

	fmk-aws-language "$search"
	fmk-aws-entity "$search"
	fmk-aws-key-phrases "$search"
	fmk-aws-sentiment "$search"

}


###############################
### End other  ################
###############################



###############################
### Start add keys ############
###############################

# Find listening port
function fmk-git-keys(){
	if [ -z "$SSH_AUTH_SOCK" ] ; then
  		eval `ssh-agent -s`
  		ssh-add
	fi
}

###############################
### End other  ################
###############################


###############################
### Start ALIAS ###############
###############################

alias br=". ~/.bash_profile"
alias aws='docker run --rm -t $(winpty &>/dev/null && echo "-i") -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" -v "//c//repo//aws-cli:/project" mesosphere/aws-cli'

###############################
### End ALIAS #################
###############################


####
### Include other things
####

if [ -f /c/Users/ciucu/.bash_profile_secret ]; then
    . /c/Users/ciucu/.bash_profile_secret
fi


####
### End include other things
####

