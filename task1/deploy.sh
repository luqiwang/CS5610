#!/bin/bash

export PORT=5300
export MIX_ENV=prod
export GIT_PATH=/home/tracker/src/task1

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "tracker" ]; then
	echo "Error: must run as user 'tracker'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/task1 ]; then
	echo mv ~/www/task1 ~/old/$NOW
	mv ~/www/task1 ~/old/$NOW
fi

mkdir -p ~/www/task1
REL_TAR=~/src/task1/_build/prod/rel/task1/releases/0.0.1/task1.tar.gz
(cd ~/www/task1 && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tracker/src/task1/start.sh
CRONTAB

#. start.sh
