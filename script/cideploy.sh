#!/bin/bash

openssl aes-256-cbc -K $encrypted_4ffc634c0a1c_key -iv $encrypted_4ffc634c0a1c_iv -in .travis_id_rsa.enc -out deploy_key.pem -d
eval "$(ssh-agent -s)"
chmod 600 deploy_key.pem
#mkdir -p ~/.ssh
#cp -f deploy_key.pem ~/.ssh/id_rsa
ssh-add deploy_key.pem
ssh-keyscan playbookstest-rhtconsulting.rhcloud.com >> ~/.ssh/known_hosts
cd _site/
git config user.name "Travis"
git config user.emal "noreply@redhat.com"
git init
git add *
git commit -m "Deploy for ${TRAVIS_COMMIT}"
git remote add deploy ssh://564b93450c1e666a530000d1@playbookstest-rhtconsulting.rhcloud.com/~/git/playbookstest.git/
git push --force deploy