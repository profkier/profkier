#!/bin/bash

# Plibrary Migration Helper Script
# This script helps migrate the Plibrary branch to a new repository

set -e

echo "=== Plibrary Branch Migration Helper ==="
echo

# Check if required tools are available
if ! command -v git &> /dev/null; then
    echo "Error: Git is required but not installed."
    exit 1
fi

# Get user input
read -p "Enter the URL of your NEW private repository (e.g., https://github.com/username/plibrary-personal.git): " NEW_REPO_URL
echo

if [ -z "$NEW_REPO_URL" ]; then
    echo "Error: Repository URL is required."
    exit 1
fi

# Extract repository name for directory
REPO_NAME=$(basename "$NEW_REPO_URL" .git)
echo "Repository name: $REPO_NAME"
echo

# Create working directory
WORK_DIR="plibrary-migration-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "Working in directory: $(pwd)"
echo

# Step 1: Clone the original repository
echo "Step 1: Cloning original repository..."
git clone https://github.com/profkier/profkier.git
cd profkier

# Step 2: Fetch and checkout the target branch
echo "Step 2: Fetching target branch..."
git fetch origin copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
git checkout copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c

# Step 3: Prepare new repository
echo "Step 3: Preparing new repository..."
cd ..
mkdir "$REPO_NAME"
cd "$REPO_NAME"

# Copy all files except .git
echo "Step 4: Copying files..."
cp -r ../profkier/* . 2>/dev/null || true
cp ../profkier/.[!.]* . 2>/dev/null || true

# Remove any .git directory that might have been copied
rm -rf .git

# Initialize new repository
git init
git remote add origin "$NEW_REPO_URL"

# Step 5: Commit files
echo "Step 5: Committing files..."
git add .
git commit -m "Initial import of Plibrary personal book tracker

Migrated from profkier/profkier branch copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
Original commit: d939cd30e80131fce6aaa9c571cebf898ad49492

This is a clone of the Plibrary project for educational purposes."

echo "Step 6: Pushing to new repository..."
git branch -M main

# Ask user if they want to push now
echo
read -p "Ready to push to the new repository? This will upload all files. (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push -u origin main
    echo "✅ Successfully pushed to new repository!"
else
    echo "⚠️  Push skipped. You can push manually later with: git push -u origin main"
fi

echo
echo "=== Migration Summary ==="
echo "✅ Files copied from branch copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c"
echo "✅ New repository initialized in: $(pwd)"
echo "✅ Files committed and ready to push"
echo
echo "Next steps:"
echo "1. Verify the migration worked correctly"
echo "2. Test the web application by opening index.html"
echo "3. Delete the original branch with:"
echo "   cd ../profkier"
echo "   git checkout main"
echo "   git push origin --delete copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c"
echo
echo "Migration helper completed!"