#!/bin/bash
set -e

# Build the site
hugo

# Go into the public folder
cd public

# Sync with remote changes (avoid push conflicts)
git pull origin main

# Deploy public
git add .
git commit -m "Deploy site: $(date '+%Y-%m-%d %H:%M')"
git push origin main

# Commit and push main repo changes
cd ..
git add .
git commit -m "Site update: $(date '+%Y-%m-%d %H:%M')"
git push origin main

