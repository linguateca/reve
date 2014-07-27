#!/bin/sh

rsync -aSPvz . --exclude ".git" --exclude "config.yml" --exclude "db/reve.sqlite" asimoes@linguateca:Reve/ 

ssh linguateca "chmod -R a+rwxt Reve/db"
