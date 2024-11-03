
# Git Version Control Cheat Sheet 

## Table of Contents
- [Repository Initialization](#repository-initialization)
- [Commit Management](#commit-management)
- [Pull/Push Operations](#pullpush-operations)
- [Merge Operations](#merge-operations)
- [Cache/Checkout](#cachecheckout)

---

## Repository Initialization

### 1. **Initialize a New Git Repository**
Setting up a repository is the first step in version control. Ensure that you are in the correct directory.
```bash
git init
```
- This creates a `.git/` directory, where all Git configuration and tracking data will reside.
  
### 2. **Clone an Existing Repository**
If you're working with an existing repository, clone it to your local machine.
```bash
git clone <repository-url>
```

---

## Commit Management

### 1. **Stage Changes for Commit**
Use `git add` to stage files for your next commit. You can add individual files or all changes at once.
```bash
git add <file-name>      # Add specific file
git add .                # Stage all changes
```

### 2. **Create a Commit**
A commit captures the current state of the staged files. Always write a clear commit message.
```bash
git commit -m "Descriptive commit message"
```

### 3. **Commit with Detailed Message (Multiline)**
For more detailed commits, a multi-line description can provide better context.
```bash
git commit
# This opens the editor, where you can write detailed explanations.
```

### 4. **Amend a Commit**
If you've made a mistake in your last commit message or forgot to stage something, you can amend the previous commit.
```bash
git commit --amend
```

---

## Pull/Push Operations

### 1. **Pull Changes from Remote**
Ensure that your local repository is up-to-date with the remote repository. This pulls any new commits from the remote.
```bash
git pull origin <branch-name>
```

### 2. **Push Local Changes to Remote**
After making changes and committing them locally, push the updates to the remote repository.
```bash
git push origin <branch-name>
```
- Make sure you are pushing to the correct branch to avoid any conflicts.

### 3. **Force Push (With Caution)**
Use `--force` only when absolutely necessary, such as after a history rewrite. This is **not** recommended in shared branches.
```bash
git push --force
```

---

## Merge Operations

### 1. **Merge Branches**
To bring changes from another branch into your current branch, use `merge`. First, ensure you are on the target branch.
```bash
git checkout <target-branch>
git merge <source-branch>
```

### 2. **Merge Conflict Resolution**
When Git cannot automatically merge changes, you must resolve conflicts manually.
- Git marks conflict areas in the file like this:
```diff
<<<<<<< HEAD
Changes in the current branch
=======
Changes from the other branch
>>>>>>> source-branch
```
- After resolving conflicts, mark the file as resolved:
```bash
git add <conflicted-file>
git commit
```

---

## Cache/Checkout

### 1. **View Cached Changes (Staged Files)**
To inspect staged files, use:
```bash
git diff --cached
```

### 2. **Checkout a Different Branch**
Switch between branches with `checkout`. This changes your working directory to reflect the state of the branch.
```bash
git checkout <branch-name>
```

### 3. **Create and Switch to a New Branch**
When working on a new feature or task, create a new branch:
```bash
git checkout -b <new-branch-name>
```

### 4. **Checkout a Previous Commit**
To view a previous commit without altering the current branch:
```bash
git checkout <commit-hash>
```

### 5. **Undo Changes in Staged Files**
If you accidentally staged changes that you don’t want to commit, use:
```bash
git reset HEAD <file-name>
```

---

## Advanced Tips

### 1. **Stash Changes**
To temporarily save uncommitted changes, allowing you to work on something else:
```bash
git stash
```
- To reapply stashed changes later:
```bash
git stash apply
```

### 2. **Rebase (Advanced History Management)**
To reapply commits on top of another base commit, use:
```bash
git rebase <branch-name>
```
This rewrites the commit history and can help create a cleaner project timeline.

### 3. **Check Git Logs**
For a detailed history of changes:
```bash
git log --oneline --graph --decorate --all
```

---

## Conclusion
Effective use of Git allows smooth collaboration, efficient version control, and streamlined development processes. Ensure that you follow best practices for commit messages, branch management, and merging to avoid common pitfalls in team-based projects.


[Back to Main Page](./README.md)