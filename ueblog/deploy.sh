#!/bin/bash
set -e

# Build the site with the correct theme
hugo -t hugo-brewm

# Go into the public folder
cd public

# Ensure we're on the right branch
git checkout main

# Sync with remote changes (avoid push conflicts)
git pull origin main

# Stage and commit the rebuilt site
git add .
git commit -m "Deploy site $(date)"

# Push to GitHub Pages
git push origin main

# Go back up
cd ..

