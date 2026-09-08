# Automation Scripts

This folder contains helper scripts for repository maintenance.

## auto_day_update.ps1

Use this script after creating a new Day folder and its markdown documentation. The script:

1. Finds the newest Day folder by default, or uses the folder name passed as `-DayFolder`.
2. Updates the main project README roadmap row to mark the new day as completed.
3. Stages the new folder and the README.
4. Creates a commit message based on the detected day number and title.
5. Pushes to the configured GitHub remote unless `-NoPush` is supplied.

Example:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\auto_day_update.ps1 -DayFolder Day-08-New-Admin-Account-Created -CommitMessage "Add Day 08 new admin account created documentation"
```

This script is intended for a controlled, repository-local workflow and should be run only after the documentation files are present in the workspace.
