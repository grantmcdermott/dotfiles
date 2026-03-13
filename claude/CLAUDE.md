# CLAUDE.md - Global Defaults

## General Principles

- Write minimal code; avoid verbose implementations
- Explain **what** and **why**, not obvious **how**
- Be concise and direct — skip flattery and filler
- Where possible, confirm and consult with source documentation
- Acknowledge limitations rather than guessing

## Git

### Commit Messages

All commit messages should follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- feat: A new feature
- fix: A bug fix
- docs: Documentation only changes
- style: Changes that do not affect the meaning of the code
- refactor: A code change that neither fixes a bug nor adds a feature
- perf: A code change that improves performance
- test: Adding missing tests or correcting existing tests
- chore: Changes to the build process or auxiliary tools
- ci: Changes to CI configuration files and scripts

Best practices:
- Use the imperative mood ("add" not "added" or "adds")
- Don't end the subject line with a period
- Limit the subject line to 50 characters
- Separate subject from body with a blank line
- Use the body to explain what and why vs. how
- Wrap the body at 72 characters

Example:
```
feat(api): Add rate limiting to authentication endpoints

Implement token bucket algorithm for rate limiting on login and
registration endpoints. Limits are configurable via environment
variables and default to 100 requests per minute per IP.

Closes #123
```

### Git Repository Integrity Rules

These rules ensure project integrity while allowing practical development workflows. The key principle: **commits in a remote repository are immutable** (with rare exeptions; requiring explicit override).

#### 1. Never delete or corrupt Git internals
- The `.git` directory must never be modified directly
- Never run commands that would delete or corrupt Git history
- Do not use `git filter-branch` or similar commands that destructively rewrite history

#### 2. Remote history is sacrosanct
- Never force push (`git push --force` or `git push -f`); unless the user explicitly requests it under instruction of the risks
- Avoid rewriting, amending, or rebasing commits that have been pushed. Exceptions must be explicitly approved by the user

#### 3. Local history can be cleaned before sharing
**Important**: Always `git fetch` before assuming commits are local-only.

The following are acceptable for commits that have **not** been pushed (only exist locally):
- Amending the most recent commit (`git commit --amend`)
- Soft/mixed reset to restructure unpushed work (`git reset --soft`, `git reset`)

Do not use interactive mode with rebase (`git rebase -i`) — it doesn't work well in CLI environments.

**Squashing commits:**

To squash commits from a feature branch onto the main branch:
1. Fetch the latest remote state (`git fetch`)
2. Checkout the main branch (`git checkout main`)
3. Squash the commits from the feature branch (`git merge --squash $FEATURE_BRANCH_NAME`)
4. Commit the squashed content with a high quality commit message following the rules above

To squash commits within a single branch:
1. Ensure your working directory is clean (no uncommitted changes)
2. Fetch the latest remote state (`git fetch`)
3. Reset to the point where your local work diverged (`git reset --soft origin/main`)
   - This keeps all your changes staged but removes the local commits
   - You MUST use the `--soft` flag with `git reset`
4. Commit the squashed content with a high quality commit message

Avoid even locally:
- Hard reset (`git reset --hard`) — too easy to lose work
- Cleaning untracked files (`git clean`) — might have important work that hasn't been committed

#### Rationale
These rules exist to ensure that:
1. Shared history remains stable for all collaborators
2. Local workflows remain flexible for crafting clean commits
3. We can revert to previous states if something goes wrong

#### Emergency Recovery
If these rules are accidentally violated:
1. STOP IMMEDIATELY - Do not attempt further Git operations that might compound the problem
2. Document what happened and what was lost and inform the user
3. Consider creating a new branch from the last known good state
4. If Git history is corrupted, preserve the working directory before attempting recovery
