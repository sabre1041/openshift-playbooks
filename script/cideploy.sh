#!/bin/bash

openssl aes-256-cbc -K "bad" -iv "bad" -in .travis_id_rsa.enc -out deploy_key.pem -d
ls -la
eval "$(ssh-agent -s)"
mkdir ~/.ssh
cp -f deploy_key.pem ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
ssh-keyscan playbookstest-rhtconsulting.rhcloud.com >> ~/.ssh/known_hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts
cd _site/
git config user.name "Travis"
git config user.emal "noreply@redhat.com"
git init
git add *
git commit -m "Deploy for ${TRAVIS_COMMIT}"
git remote add deploy ssh://564b93450c1e666a530000d1@playbookstest-rhtconsulting.rhcloud.com/~/git/playbookstest.git/
git push --force deploy