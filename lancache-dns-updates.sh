#!/bin/bash

### Set variables, change as necessary ###
# Username of the regular user you're using
SYSTEMUSER=$(logname)
# Directory the git repository is synced to
GITSYNCDIR=/home/$SYSTEMUSER/cache-domains
# Your personalized config file from "Setting up our config.json file" step
DNSMASQCONFIG=/home/$SYSTEMUSER/config.json

# Create a new, random temp directory and make sure it was created, else exit
TEMPDIR=$(mktemp -d)

  if [ ! -e $TEMPDIR ]; then
      >&2 echo "Failed to create temp directory"
      exit 1
  fi

# Switch to the git directory and pull any new data
cd $GITSYNCDIR && \
  git pull > /dev/null 2>&1

# Copy the .txt files and .json file to the temp directory
cp `find $GITSYNCDIR -name "*.txt" -o -name cache_domains.json` $TEMPDIR

# Copy the create-dnsmasq.sh script to our temp directory
mkdir $TEMPDIR/scripts/ && \
  cp $GITSYNCDIR/scripts/create-dnsmasq.sh $TEMPDIR/scripts/ && \
  chmod +x $TEMPDIR/scripts/create-dnsmasq.sh

# Copy the config over
cp $DNSMASQCONFIG $TEMPDIR/scripts/

# Generate the dnsmasq files with the script
cd $TEMPDIR/scripts/ && \
  bash ./create-dnsmasq.sh > /dev/null 2>&1

# Copy the dnsmasq files
cp -r $TEMPDIR/scripts/output/dnsmasq/*.conf /etc/dnsmasq.d/

# Restart pihole-FTL or docker
if systemctl is-active --quiet pihole-FTL ; then
  sudo service pihole-FTL restart
elif sudo docker ps -a | grep -o "pihole" > /dev/null 2>&1 ; then
  sudo docker restart pihole > /dev/null 2>&1
fi

# Delete the temp directory to clean up files
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPDIR"' EXIT
