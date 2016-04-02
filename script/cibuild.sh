#!/bin/bash
set -e

bundle exec jekyll build
bundle exec htmlproof ./_site