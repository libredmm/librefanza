#!/bin/bash

DEPLOY_DEST=librefanza

scp .env .env.production $DEPLOY_DEST:~/librefanza/
ssh $DEPLOY_DEST "cd ~/librefanza && git pull --rebase && sudo docker compose up --build -d"
