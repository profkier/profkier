#!/bin/bash

# Branch Cleanup Script
# This script helps delete the original Plibrary branch after successful migration

set -e

echo "=== Plibrary Branch Cleanup Helper ==="
echo "⚠️  WARNING: This will permanently delete the branch from GitHub!"
echo "   Make sure you have successfully migrated the content to the new repository first."
echo

# Confirm with user
read -p "Have you successfully migrated the Plibrary content to a new repository? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborting cleanup. Please complete the migration first."
    exit 1
fi

# Double confirmation
echo
echo "This will delete the branch: copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c"
read -p "Are you absolutely sure you want to proceed? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "❌ Cleanup cancelled."
    exit 1
fi

# Check if we're in the right repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository."
    echo "Please run this script from the profkier repository directory."
    exit 1
fi

# Check if we're in the profkier repository
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [[ ! "$REMOTE_URL" =~ "profkier/profkier" ]]; then
    echo "❌ Error: This doesn't appear to be the profkier/profkier repository."
    echo "Current remote: $REMOTE_URL"
    echo "Expected: something containing 'profkier/profkier'"
    exit 1
fi

echo
echo "🔍 Checking current status..."

# Make sure we're not on the branch we're about to delete
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
TARGET_BRANCH="copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c"

if [ "$CURRENT_BRANCH" = "$TARGET_BRANCH" ]; then
    echo "📍 Currently on target branch. Switching to main..."
    git checkout main
fi

# Check if the branch exists locally
if git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
    echo "🗑️  Deleting local branch..."
    git branch -D "$TARGET_BRANCH"
    echo "✅ Local branch deleted"
else
    echo "ℹ️  Local branch not found (may have been deleted already)"
fi

# Check if the branch exists remotely
if git ls-remote --exit-code --heads origin "$TARGET_BRANCH" >/dev/null 2>&1; then
    echo "🗑️  Deleting remote branch..."
    git push origin --delete "$TARGET_BRANCH"
    echo "✅ Remote branch deleted"
else
    echo "ℹ️  Remote branch not found (may have been deleted already)"
fi

echo
echo "=== Cleanup Complete ==="
echo "✅ Branch copilot/fix-230d2c2b-6ecd-4051-a57e-5583fbe7d29c has been deleted"
echo "✅ The Plibrary content should now only exist in your new private repository"
echo
echo "You can verify the deletion by checking:"
echo "  - GitHub web interface"
echo "  - git branch -a (should not show the deleted branch)"
echo
echo "Cleanup completed successfully!"