# Migration Instructions: Moving Plibrary Branch to Separate Repository

## Overview
This document provides step-by-step instructions to move the branch `copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c` containing the Plibrary project to its own separate private repository and delete the original branch.

## Current Situation
- **Repository**: profkier/profkier
- **Branch to migrate**: `copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c`
- **Content**: Complete Plibrary personal book tracker web application
- **Commit**: d939cd30e80131fce6aaa9c571cebf898ad49492

## Prerequisites
1. GitHub account with ability to create private repositories
2. Git installed locally
3. GitHub CLI (gh) or web interface access

## Step-by-Step Migration Process

### Step 1: Create New Private Repository
1. Go to GitHub.com and click "New repository"
2. Name it something like `plibrary-personal` or `book-tracker-app`
3. Set visibility to **Private**
4. Do NOT initialize with README, .gitignore, or license (we'll import existing content)
5. Click "Create repository"

### Step 2: Clone and Setup Local Environment
```bash
# Clone the original repository
git clone https://github.com/profkier/profkier.git
cd profkier

# Fetch the specific branch
git fetch origin copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
git checkout copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
```

### Step 3: Prepare New Repository
```bash
# Create a new directory for the new repository
cd ..
mkdir plibrary-personal
cd plibrary-personal

# Initialize new git repository
git init

# Add the new private repository as remote
git remote add origin https://github.com/[YOUR-USERNAME]/[NEW-REPO-NAME].git
```

### Step 4: Copy Content
```bash
# Copy all files from the branch (excluding .git)
cp -r ../profkier/* .
cp -r ../profkier/.* . 2>/dev/null || true

# Remove the .git directory to avoid conflicts
rm -rf .git
git init
git remote add origin https://github.com/[YOUR-USERNAME]/[NEW-REPO-NAME].git
```

### Step 5: Commit and Push to New Repository
```bash
# Stage all files
git add .

# Commit with appropriate message
git commit -m "Initial import of Plibrary personal book tracker

Migrated from profkier/profkier branch copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
Original commit: d939cd30e80131fce6aaa9c571cebf898ad49492

This is a clone of the Plibrary project for educational purposes."

# Push to new repository
git branch -M main
git push -u origin main
```

### Step 6: Verify Migration
1. Check that all files are present in the new repository
2. Test the web application by opening index.html
3. Verify the README and LICENSE are correct
4. Ensure the repository is set to private

### Step 7: Delete Original Branch
```bash
# Go back to original repository
cd ../profkier

# Switch to a different branch (not the one being deleted)
git checkout main

# Delete the local branch
git branch -D copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c

# Delete the remote branch
git push origin --delete copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
```

### Alternative: Using GitHub CLI
If you have GitHub CLI installed:

```bash
# Create new private repository
gh repo create plibrary-personal --private --description "Personal book tracker application"

# Follow steps 2-4 above, then:
gh repo clone [YOUR-USERNAME]/plibrary-personal
# Copy files and commit as above

# Delete branch
gh api -X DELETE /repos/profkier/profkier/git/refs/heads/copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c
```

## Verification Checklist
- [ ] New private repository created
- [ ] All files from original branch copied successfully
- [ ] Web application works in new repository
- [ ] Original branch deleted from profkier/profkier
- [ ] No references to original repository remain
- [ ] New repository is set to private

## Files Being Migrated
The following files will be moved:
- `index.html` - Main application file
- `README.md` - Project documentation
- `LICENSE` - MIT license
- `assets/` directory containing:
  - `css/styles.css` - Application styles
  - `js/script.js` - Application logic
  - `images/` - Icons and logos
  - `designs/` - Design mockups

## Notes
- The new repository will maintain the original MIT license
- Consider updating the README to reflect the new repository location
- Update any hardcoded URLs in the HTML meta tags if needed
- The commit history will start fresh in the new repository

## Troubleshooting
- If you get permission errors, ensure you have write access to both repositories
- If the branch doesn't exist locally, make sure to fetch it first
- If you accidentally delete the wrong branch, it can be recovered from the GitHub interface within 30 days

## Contact
If you need assistance with this migration, please refer to the GitHub documentation or contact support.