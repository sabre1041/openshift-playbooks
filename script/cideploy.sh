#!/bin/bash


function generate_statistics() {
   
    echo "Pull Request: ${TRAVIS_PULL_REQUEST}"
    echo "Pull Request Commit Range: ${TRAVIS_PULL_REQUEST}"

}


# Determine which Git configurations to use. PR's go to Test
if [ "$TRAVIS_PULL_REQUEST" == false ]; then
    git_repo=$git_repo_prod
    git_host=$git_host_prod
else
    git_repo=$git_repo_test
    git_host=$git_host_test
fi

echo "Git Repository: ${git_repo}"
echo "Git PR Commit Range: ${TRAVIS_COMMIT_RANGE}"
echo "Git PR Commit Range Fix: ${TRAVIS_COMMIT_RANGE/.../..}"


# Deploy site if on master branch and not PR
if [ "$TRAVIS_BRANCH" == "master" ] || [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    
    # If Pull Request, Create Statistics
    if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
        generate_statistics
    fi
    
    # Decrypt private key
    openssl aes-256-cbc -K $encrypted_4ffc634c0a1c_key -iv $encrypted_4ffc634c0a1c_iv -in .travis_id_rsa.enc -out deploy_key.pem -d

    eval "$(ssh-agent -s)"
    cp -f deploy_key.pem ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    ssh-add ~/.ssh/id_rsa
    ssh-keyscan $git_host >> ~/.ssh/known_hosts
    cd _site/
    git init
    git config user.name "Travis"
    git config user.emal "noreply@redhat.com"
    git add *
    git commit -m "Deploy for ${TRAVIS_COMMIT}"
    git remote add deploy $git_repo
    git push --force deploy
    
    #TODO: Notifications
    
else
    echo "Skipping deployment. Not on master branch or a pull request"
fi