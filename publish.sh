#!/bin/sh

rsync -aSPvz . --exclude ".git" --exclude "config.yml" --exclude "db/reve.sqlite" asimoes@dinis2:playground/reve/ 

ssh asimoes@dinis2 "chmod -R a+rwxt playground/reve/db"
