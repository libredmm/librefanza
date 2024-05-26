#!/bin/bash

DEPLOY_HOST="librefanza"
DEPLOY_PATH="~/librefanza"

git push &&
scp .env .env.production $DEPLOY_HOST:$DEPLOY_PATH &&
ssh $DEPLOY_HOST "cd $DEPLOY_PATH && git pull --rebase && sudo docker compose up --build -d"
