#!/bin/bash

APP_DIR="$HOME/workshop/vPair/apps"
PARSEC="$APP_DIR/parsec"
PHOENIX="$APP_DIR/phoenix"
IMAGIC="$APP_DIR/ImageMagick6"

pushd $PARSEC
git add -A
git commit -m "update parsec app"
git push
popd

pushd $PHOENIX
git add -A
git commit -m "update phoenix app"
git push
popd

pushd $IMAGIC
git add -A
git commit -m "update imagemagic app"
git push
popd


git pull
git submodule foreach git pull origin master
git add -A
git commit -m "update submodule"
git push
