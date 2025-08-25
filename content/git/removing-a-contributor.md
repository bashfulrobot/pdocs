---
title: "Removing a Contributor from a GitHub Repository"
weight: 10
geekdocAnchor: true
geekdocToC: 3
---

This guide outlines the complete process for removing a contributor from a GitHub repository, including rewriting Git history to remove their commits and forcing cache updates on GitHub to reflect the changes.

## Overview

Removing a contributor from a repository involves several steps:

- **History Rewriting** - Remove contributor commits using `git filter-repo`
- **Force Push** - Update the remote repository with cleaned history  
- **Cache Invalidation** - Force GitHub to refresh contributor data
- **Support Contact** - Final escalation if automated methods fail

## Prerequisites

1. **Administrative access** to the target repository
2. **git-filter-repo** installed (available via Nix: `nix-shell -p git-filter-repo`)
3. **GitHub CLI (gh)** for repository management
4. **Backup** of the repository before making destructive changes

## Process

### 1. Rewrite Git History

The first step is to remove the contributor's commits from the Git history using `git filter-repo`, a powerful and safe tool for rewriting repository history.

#### Basic Path Removal

```bash
git filter-repo --invert-paths --path-to-remove path/to/contributors/code
```

#### Commit Message Cleanup

To remove specific commit message content (such as `Co-Authored-By` trailers):

```bash
nix-shell -p git-filter-repo --run "git filter-repo --message-callback 'return re.sub(b"\\n\\nCo-Authored-By: Claude <noreply@anthropic.com>\\n", b"", message)' --force"
```

This command uses `git filter-repo` to rewrite commit messages and remove the specified `Co-Authored-By` trailer.

### 2. Force Push to Remote

Once the history has been rewritten, force push the changes to overwrite the existing history on the remote repository.

```bash
git push --force
```

### 3. Force GitHub Cache Update

Even after rewriting history and force-pushing changes, the old contributor may still appear on GitHub due to caching. Use these methods to force a cache update:

#### Method A: Branch Rename Strategy

Renaming the default branch can trigger cache invalidation on GitHub:

1. **Rename the local branch:**
   ```bash
   git branch -m main main-temp
   ```

2. **Push the renamed branch:**
   ```bash
   git push origin main-temp
   ```

3. **Update GitHub's default branch:**
   ```bash
   gh repo edit <owner>/<repo> --default-branch main-temp
   ```

4. **Remove the old branch:**
   ```bash
   git push origin --delete main
   ```

5. **Rename back to original:**
   ```bash
   git branch -m main-temp main
   ```

6. **Push the restored branch:**
   ```bash
   git push origin main
   ```

7. **Restore default branch setting:**
   ```bash
   gh repo edit <owner>/<repo> --default-branch main
   ```

8. **Clean up temporary branch:**
   ```bash
   git push origin --delete main-temp
   ```

#### Method B: Empty Commit

If branch renaming doesn't trigger the cache update, try pushing an empty commit:

```bash
git commit --allow-empty -m "chore: trigger github cache update"
git push
```

### 4. Contact GitHub Support

If automated methods fail and the contributor still appears after trying all previous steps, contact GitHub Support for manual cache refresh.

## Troubleshooting

### Common Issues

**git-filter-repo not found:**
```bash
# Install via Nix
nix-shell -p git-filter-repo

# Or install globally
nix-env -iA nixpkgs.git-filter-repo
```

**Force push rejected:**
- Verify you have admin access to the repository
- Check if branch protection rules prevent force pushes
- Temporarily disable branch protection if needed

**GitHub CLI authentication:**
```bash
# Login to GitHub CLI
gh auth login

# Verify authentication
gh auth status
```

## Security Considerations

- **Backup First** - Always create a backup before rewriting history
- **Coordinate with Team** - Notify team members of history rewriting
- **Update Local Clones** - Team members will need to re-clone or reset their local repositories
- **Review Changes** - Verify the contributor has been completely removed

## Resources

- **git-filter-repo Documentation**: [GitHub Repository](https://github.com/newren/git-filter-repo)
- **GitHub CLI**: [Official Documentation](https://cli.github.com/)
- **Git Documentation**: [Git SCM](https://git-scm.com/doc)

```