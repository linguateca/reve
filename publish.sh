#!/bin/sh

rsync -aSPvz . --exclude "*~" --exclude ".git" --exclude "config.yml" --exclude "db/reve.sqlite" asimoes@linguateca:Reve/ 

ssh linguateca "chmod -R a+rwxt Reve/db"
ssh -t linguateca "sudo service httpd restart"
