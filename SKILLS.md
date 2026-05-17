# SKILLS.md

Available Claude Code skills for this project.

## Skills

### `init`
Analyzes the codebase and creates or updates `CLAUDE.md` with commands, architecture, and project-specific guidance.

### `review`
Reviews a pull request — reads the diff and relevant context, then reports issues by severity.

### `security-review`
Audits pending branch changes for security issues (auth logic, token handling, injection risks, etc.).

### `simplify`
Reviews recently changed code for reuse, quality, and efficiency, then applies fixes.

### `update-config`
Configures Claude Code settings (`settings.json`) — permissions, env vars, hooks (automated behaviors triggered on tool events).

### `keybindings-help`
Customizes keyboard shortcuts in `~/.claude/keybindings.json`.

### `fewer-permission-prompts`
Scans recent transcripts for common read-only tool calls and adds an allowlist to `.claude/settings.json` to reduce prompts.

### `schedule`
Creates, lists, or manages scheduled remote agents (cron-based routines or one-time runs).

### `loop`
Runs a prompt or slash command on a recurring interval (e.g. `/loop 5m /review`).

### `claude-api`
Builds, debugs, and optimizes Claude API / Anthropic SDK integrations, including prompt caching and model migrations.

## Usage

Invoke any skill by typing `/<skill-name>` in the Claude Code prompt. Example:

```
/review
/security-review
/simplify
```
