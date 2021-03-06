#!/bin/bash -e
. /opt/bitnami/base/functions

print_welcome_page
check_for_updates &

PROJECT_DIRECTORY=/app/$SYMFONY_PROJECT_NAME
DEPLOY="$@"

echo "Starting application ..."

if [ "$1" == "php" -a "$2" == "-S" ] ; then
  if [ ! -d $PROJECT_DIRECTORY ] ; then
    log "Creating example Symfony application"
    nami execute symfony createProject --databaseServerHost $MARIADB_HOST --databaseServerPort $MARIADB_PORT --databaseAdminUser $MARIADB_USER $SYMFONY_PROJECT_NAME | grep -v undefined
    log "Symfony app created"
  else
    log "App already created"
  fi
  if [ ! -f $PROJECT_DIRECTORY/web/index.php ] ; then
    sudo ln -s $PROJECT_DIRECTORY/web/app.php $PROJECT_DIRECTORY/web/index.php
  fi
  DEPLOY="$@ -t $PROJECT_DIRECTORY/web/"
fi

echo "symfony successfully initialized"

exec tini -- $DEPLOY
