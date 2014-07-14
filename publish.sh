#!/bin/sh

rsync -aSPvz . --exclude "config.yml" asimoes@dinis2:playground/reve/ 

ssh asimoes@dinis2 "chmod -R a+rwxt playground/reve/db"
