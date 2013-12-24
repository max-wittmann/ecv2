#!/bin/bash

#Create with no password or modify in database.yml

#Note, this will create only ONE db for prod, test and deploy (so it'll get overwritten for tests)
#Also, requires ./configs/database.yml to be changed; the _test, _deploy and _production extensions
# to db names must be removed

sudo -u mwittman createuser -d -R -P mostly_static_pages
sudo -u mwittman createdb -O mostly_static_pages mostly_static_pages
