#!/bin/bash
set -e

# Build the site with the correct theme
hugo -t hugo-brewm

# Ensure we're on the right branch
git checkout main

# Commit and push main repo changes
git add .
git commit -m "Site update: $(date '+%Y-%m-%d %H:%M')"
git push origin main

# Go into the public folder
cd public

# Sync with remote changes (avoid push conflicts)
git pull origin main

# Deploy public
cd public
git add .
git commit -m "Deploy site: $(date '+%Y-%m-%d %H:%M')"
git push origin main
cd ..
