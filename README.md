# Zsh Configuration

Personal zsh configuration file with custom functions, aliases, and development tools setup.

## Features

### Oh-My-Zsh Setup
- **Theme**: Gitster
- **Plugins**: git, zsh-syntax-highlighting, vi-mode
- **Vi-mode customization**: Press `jj` in insert mode to enter command mode
- **Fast key timeout**: 50ms for responsive vi-mode switching

### Worktree Management System

A comprehensive unified git worktree management system for working with multiple branches simultaneously. All worktree operations are now consolidated under a single `worktree` command with subcommands.

#### Commands

- `worktree new <name> [base]` - Create a new worktree from a base branch (defaults to current branch)
  - Example: `worktree new feature-x` creates from current branch
  - Example: `worktree new feat/my-feature main` creates from main branch
  - Example: `worktree new existing-branch` creates worktree for an existing branch
  - Supports branch names with slashes (e.g., `feat/my-feature`)
  - Automatically launches Claude CLI after creation
  - **Smart branch detection**: If the branch already exists, creates a worktree for it; otherwise creates a new branch
  
- `worktree <name>` - Switch to an existing worktree (with tab completion)
  - Example: `worktree feat/my-feature`
  - Smart completion shows all available worktrees
  
- `worktree main` - Return to main working directory
  - Smart detection: returns to studio main if currently in studio worktree
  
- `worktree delete <name>` - Delete a worktree and its branch (with tab completion)
  - Includes safety checks to prevent deleting the worktree you're currently in
  - Prompts for confirmation before deletion
  - Cleans up both the worktree and the git branch
  
- `worktree list` - List all available worktrees
  - Shows worktrees from both root and studio locations
  - Displays actual branch names for clarity

#### Features

- **Unified Interface**: All worktree operations under one command
- **Smart Completion**: Context-aware tab completion for all subcommands
- **Dual Location Support**: Manages worktrees in both frontend root and studio
- **Safety Checks**: Prevents accidental deletion and duplicate worktrees
- **Branch Name Flexibility**: Supports slashes in branch names (converted to hyphens for directory names)
- **Existing Branch Support**: Automatically detects and creates worktrees for existing branches
- **Tmux Integration**: Automatically renames tmux windows to match the worktree name when switching or creating worktrees

**Note**: The worktree system is configured for the Reducto frontend repo at `/Users/omar/reducto/frontend`

### Aliases

- `clc` - Launch Claude CLI with dangerous skip permissions
- `zine` - Navigate to Zine project
- `untar` - Extract and remove tar.gz files
- `reducto` - Navigate to Reducto project
- `krenew` - Renew Kerberos ticket
- `tailscale` - Run Tailscale from Applications
- `workspace` - Navigate to workspace directory

### Functions

- `addbackground()` - Download an image and save it to desktop backgrounds folder
  - Usage: `addbackground <url>`

### Development Tools

#### Version Managers
- **NVM**: Lazy-loaded Node Version Manager
- **rbenv**: Ruby version manager
- **conda**: Python environment manager (Miniconda3)

#### Package Managers
- **Bun**: JavaScript runtime and package manager
- **pipx**: Python application installer

#### Shell Enhancements
- **Atuin**: Shell history sync and search (bound to Ctrl+R)
- **Syntax highlighting**: Real-time command syntax highlighting

### Editor Configuration
- Default editor: `vim`
- Terminal type: `xterm`

### Additional Features
- Auto-correction enabled for commands
- Untracked files marked as dirty disabled (faster for large repos)
- Completion fix disabled
- Beep sounds disabled

## Installation

1. Copy the `zshrc` file to your home directory:
   ```bash
   cp zshrc ~/.zshrc
   ```

2. Source the file or restart your terminal:
   ```bash
   source ~/.zshrc
   ```

## Requirements

- Oh-My-Zsh installed at `~/.oh-my-zsh`
- zsh-syntax-highlighting plugin
- Optional: NVM, rbenv, conda, Bun, Atuin for full functionality

## Path Additions

The configuration adds the following to your PATH:
- `/usr/local/bin`
- `/opt/homebrew/bin` (for Apple Silicon Macs)
- `~/.npm-global/bin`
- `~/.local/bin` (pipx)
- `/usr/local/opt/openssl@1.1/bin`
- `/usr/local/opt/python/libexec/bin`
- `~/.codeium/windsurf/bin`
- `~/.bun/bin`
- Cargo environment (Rust)
- Google Cloud SDK (if installed)

## Notes

- This configuration is personalized for a specific workflow and directory structure
- You may need to adjust paths and usernames for your system
- The worktree management system is specifically designed for the Reducto frontend repository
