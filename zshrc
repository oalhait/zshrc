# Path to your oh-my-zsh installation.
export ZSH=/Users/omar/.oh-my-zsh

# edits for zsh vi-mode to work the way I want
export KEYTIMEOUT=50
bindkey -M viins 'jj' vi-cmd-mode


# export CLICOLOR=1
# export LSCOLORS=ExFxBxDxCxegedabagacad



# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gitster"
# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
# [[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL

fpath=(/usr/local/share/zsh-completions $fpath)
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
ZSH_DISABLE_COMPFIX="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting vi-mode)

# User configuration

export PATH="/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin"
export PATH=$PATH:~/.npm-global/bin
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
export TERM='xterm'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias fcc-update="cd ~/Desktop/projects/FreeCodeCamp && git pull --rebase upstream staging && git push origin staging --force"
#alias fcc="cd ~/Desktop/projects/FreeCodeCamp"
alias clc="claude --dangerously-skip-permissions"
alias zine="cd ~/Desktop/Zine/ZineApp"
alias untar="tar -xzvf $1; rm -rf $1"
alias reducto="cd ~/reducto"
alias krenew="kinit oalhait@ANDREW.CMU.EDU"
function addbackground() {
	date="$(echo $(date +%m.%d.%y-%H:%M:%S))"
	result=$(wget $1 -O "$date.jpg")
	mv "$date.jpg" ~/Documents/desktop\ backgrounds
}

# ============================================
# WORKTREE MANAGEMENT SYSTEM
# ============================================
# Commands:
#   worktree new <name> [base]   - Create new worktree from base branch (default: current)
#   worktree <name>              - Switch to existing worktree (with tab completion)
#   worktree main                - Return to main working directory
#   worktree delete <name>       - Delete worktree and branch (with tab completion)
#   worktree list                - List all worktrees
# ============================================

function worktree() {
	local FRONTEND_ROOT="/Users/omar/reducto/frontend"
	
	# Check if we're in the frontend repo
	local current_dir="$PWD"
	if [[ ! "$current_dir" == "$FRONTEND_ROOT"* ]]; then
		echo "❌ Error: Not in frontend repo"
		return 1
	fi
	
	# No arguments - show usage
	if [ -z "$1" ]; then
		echo "Usage: worktree <command|name>"
		echo ""
		echo "Commands:"
		echo "  worktree new <name> [base]  - Create new worktree"
		echo "  worktree delete <name>      - Delete worktree and branch"
		echo "  worktree list               - List all worktrees"
		echo "  worktree main               - Return to main directory"
		echo "  worktree <name>             - Switch to worktree"
		echo ""
		echo "Examples:"
		echo "  worktree new feat/my-feature        # Create from current branch"
		echo "  worktree new feat/my-feature main   # Create from main"
		echo "  worktree feat/my-feature            # Switch to worktree"
		echo "  worktree delete feat/my-feature     # Delete worktree"
		return 1
	fi
	
	local cmd="$1"
	
	# Handle subcommands
	case "$cmd" in
		new)
			_worktree_new "${@:2}"
			;;
		delete)
			_worktree_delete "${@:2}"
			;;
		list)
			_worktree_list
			;;
		main)
			_worktree_main
			;;
		*)
			# Default: switch to worktree
			_worktree_switch "$1"
			;;
	esac
}

function _worktree_new() {
	if [ -z "$1" ]; then
		echo "Usage: worktree new <branch-name> [base-branch]"
		echo ""
		echo "Examples:"
		echo "  worktree new feature-x           # Creates from current branch"
		echo "  worktree new feat/my-feature     # Branch name with slash, dir without"
		echo "  worktree new feature-x main      # Creates from main"
		echo "  worktree new existing-branch     # Creates worktree for existing branch"
		return 1
	fi
	
	local branch_name="$1"
	local base_branch="${2:-HEAD}"
	
	# Convert slashes to hyphens for directory name
	local dir_name="${branch_name//\//-}"
	
	# Check if branch already exists
	if git rev-parse --verify "$branch_name" >/dev/null 2>&1; then
		echo "🌿 Creating worktree '$dir_name' for existing branch '$branch_name'..."
		git worktree add .claude/worktrees/$dir_name "$branch_name"
	else
		echo "🌿 Creating worktree '$dir_name' with new branch '$branch_name' from '$base_branch'..."
		git worktree add .claude/worktrees/$dir_name -b "$branch_name" "$base_branch"
	fi
	
	if [ $? -eq 0 ]; then
		cd .claude/worktrees/$dir_name
		echo "✅ Switched to branch '$branch_name'"
		
		# Rename tmux window if in tmux session
		if [ -n "$TMUX" ]; then
			tmux rename-window "$dir_name"
		fi
		
		clc
	fi
}

function _worktree_switch() {
	local FRONTEND_ROOT="/Users/omar/reducto/frontend"
	local current_dir="$PWD"
	
	# Convert slashes to hyphens for directory lookup
	local dir_name="${1//\//-}"
	
	# Search for the worktree
	local root_worktree="$FRONTEND_ROOT/.claude/worktrees/$dir_name"
	local studio_worktree="$FRONTEND_ROOT/apps/studio/.claude/worktrees/$dir_name"
	
	local found_root=false
	local found_studio=false
	
	# Check if it's a valid worktree directory
	[ -d "$root_worktree" ] && found_root=true
	[ -d "$studio_worktree" ] && found_studio=true
	
	# Warn if duplicate
	if $found_root && $found_studio; then
		echo "⚠️  WARNING: Worktree '$dir_name' exists in both locations!"
		echo "   - Root: $root_worktree"
		echo "   - Studio: $studio_worktree"
		echo ""
		echo "This should never happen. Please clean up duplicates."
		return 1
	fi
	
	# Switch to worktree
	if $found_root; then
		cd "$root_worktree"
		echo "📂 Switched to worktree: $1 (root)"
		
		# Rename tmux window if in tmux session
		if [ -n "$TMUX" ]; then
			tmux rename-window "$dir_name"
		fi
		
		return 0
	elif $found_studio; then
		cd "$studio_worktree"
		echo "📂 Switched to worktree: $1 (studio)"
		
		# Rename tmux window if in tmux session
		if [ -n "$TMUX" ]; then
			tmux rename-window "$dir_name"
		fi
		
		return 0
	else
		echo "❌ Worktree '$dir_name' not found"
		echo ""
		echo "Available worktrees:"
		_worktree_list
		return 1
	fi
}

function _worktree_main() {
	local FRONTEND_ROOT="/Users/omar/reducto/frontend"
	local current_dir="$PWD"
	
	# Smart detection based on current location
	if [[ "$current_dir" == *"/apps/studio"* ]]; then
		cd "$FRONTEND_ROOT/apps/studio"
		echo "📂 Switched to studio main"
		
		# Rename tmux window if in tmux session
		if [ -n "$TMUX" ]; then
			tmux rename-window "studio-main"
		fi
	else
		cd "$FRONTEND_ROOT"
		echo "📂 Switched to frontend root"
		
		# Rename tmux window if in tmux session
		if [ -n "$TMUX" ]; then
			tmux rename-window "main"
		fi
	fi
}

function _worktree_delete() {
	local FRONTEND_ROOT="/Users/omar/reducto/frontend"
	local current_dir="$PWD"
	
	if [ -z "$1" ]; then
		echo "Usage: worktree delete <name>"
		echo ""
		echo "Available worktrees:"
		_worktree_list
		return 1
	fi
	
	# Convert slashes to hyphens for directory lookup
	local dir_name="${1//\//-}"
	local branch_name="$1"
	
	# Search for the worktree
	local root_worktree="$FRONTEND_ROOT/.claude/worktrees/$dir_name"
	local studio_worktree="$FRONTEND_ROOT/apps/studio/.claude/worktrees/$dir_name"
	
	local found_root=false
	local found_studio=false
	local worktree_path=""
	local location=""
	
	# Check if it's a valid worktree directory
	[ -d "$root_worktree" ] && found_root=true && worktree_path="$root_worktree" && location="root"
	[ -d "$studio_worktree" ] && found_studio=true && worktree_path="$studio_worktree" && location="studio"
	
	# Warn if duplicate
	if $found_root && $found_studio; then
		echo "⚠️  WARNING: Worktree '$dir_name' exists in both locations!"
		echo "   - Root: $root_worktree"
		echo "   - Studio: $studio_worktree"
		echo ""
		echo "Please specify which one to delete:"
		echo "  rm -rf $root_worktree"
		echo "  rm -rf $studio_worktree"
		return 1
	fi
	
	# Check if worktree exists
	if ! $found_root && ! $found_studio; then
		echo "❌ Worktree '$dir_name' not found"
		echo ""
		echo "Available worktrees:"
		_worktree_list
		return 1
	fi
	
	# Check if we're currently in the worktree we're trying to delete
	if [[ "$current_dir" == "$worktree_path"* ]]; then
		echo "❌ Error: Cannot delete worktree you're currently in"
		echo "💡 Switch to another location first: worktree main"
		return 1
	fi
	
	# Confirm deletion
	echo "⚠️  About to delete worktree '$dir_name' (branch: $branch_name) ($location)"
	echo "   Path: $worktree_path"
	echo ""
	read -q "REPLY?Are you sure? (y/n) "
	echo ""
	
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		# Remove the worktree
		git worktree remove "$worktree_path" --force 2>/dev/null || rm -rf "$worktree_path"
		
		# Delete the branch if it exists (use the original branch name with slashes)
		git branch -D "$branch_name" 2>/dev/null
		
		echo "✅ Deleted worktree and branch: $branch_name"
	else
		echo "❌ Cancelled"
	fi
}

function _worktree_list() {
	local FRONTEND_ROOT="/Users/omar/reducto/frontend"
	local root_dir="$FRONTEND_ROOT/.claude/worktrees"
	local studio_dir="$FRONTEND_ROOT/apps/studio/.claude/worktrees"
	
	echo "📋 Available worktrees:"
	
	local found_any=false
	
	if [ -d "$root_dir" ] && [ "$(ls -A $root_dir 2>/dev/null)" ]; then
		echo "  Root worktrees:"
		for dir in "$root_dir"/*; do
			if [ -d "$dir" ]; then
				local dir_name="$(basename "$dir")"
				# Try to get actual branch name from git
				local branch_name="$(cd "$dir" && git branch --show-current 2>/dev/null || echo "$dir_name")"
				if [ "$branch_name" = "$dir_name" ]; then
					echo "    - $dir_name"
				else
					echo "    - $branch_name"
				fi
				found_any=true
			fi
		done
	fi
	
	if [ -d "$studio_dir" ] && [ "$(ls -A $studio_dir 2>/dev/null)" ]; then
		echo "  Studio worktrees:"
		for dir in "$studio_dir"/*; do
			if [ -d "$dir" ]; then
				local dir_name="$(basename "$dir")"
				# Try to get actual branch name from git
				local branch_name="$(cd "$dir" && git branch --show-current 2>/dev/null || echo "$dir_name")"
				if [ "$branch_name" = "$dir_name" ]; then
					echo "    - $dir_name"
				else
					echo "    - $branch_name"
				fi
				found_any=true
			fi
		done
	fi
	
	if ! $found_any; then
		echo "  (none)"
	fi
}

# Autocomplete for worktree command
function _worktree_completion() {
	local FRONTEND_ROOT="/Users/omar/reducto/frontend"
	local line state
	
	_arguments -C \
		'1: :->command' \
		'*::arg:->args'
	
	case $state in
		command)
			local -a commands
			commands=(
				'new:Create new worktree'
				'delete:Delete worktree and branch'
				'list:List all worktrees'
				'main:Return to main directory'
			)
			
			# Add existing worktrees as options
			if [ -d "$FRONTEND_ROOT/.claude/worktrees" ]; then
				for dir in "$FRONTEND_ROOT/.claude/worktrees"/*; do
					if [ -d "$dir" ]; then
						local branch_name="$(cd "$dir" && git branch --show-current 2>/dev/null || basename "$dir")"
						commands+=("$branch_name:Switch to worktree")
					fi
				done
			fi
			
			if [ -d "$FRONTEND_ROOT/apps/studio/.claude/worktrees" ]; then
				for dir in "$FRONTEND_ROOT/apps/studio/.claude/worktrees"/*; do
					if [ -d "$dir" ]; then
						local branch_name="$(cd "$dir" && git branch --show-current 2>/dev/null || basename "$dir")"
						commands+=("$branch_name:Switch to worktree")
					fi
				done
			fi
			
			_describe 'worktree' commands
			;;
		args)
			case $line[1] in
				delete)
					# Autocomplete existing worktrees for delete
					local -a worktrees
					if [ -d "$FRONTEND_ROOT/.claude/worktrees" ]; then
						for dir in "$FRONTEND_ROOT/.claude/worktrees"/*; do
							if [ -d "$dir" ]; then
								local branch_name="$(cd "$dir" && git branch --show-current 2>/dev/null || basename "$dir")"
								worktrees+=("$branch_name")
							fi
						done
					fi
					
					if [ -d "$FRONTEND_ROOT/apps/studio/.claude/worktrees" ]; then
						for dir in "$FRONTEND_ROOT/apps/studio/.claude/worktrees"/*; do
							if [ -d "$dir" ]; then
								local branch_name="$(cd "$dir" && git branch --show-current 2>/dev/null || basename "$dir")"
								worktrees+=("$branch_name")
							fi
						done
					fi
					
					_describe 'worktree' worktrees
					;;
			esac
			;;
	esac
}

compdef _worktree_completion worktree


export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/omar/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/omar/Downloads/google-cloud-sdk/path.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
nvm() {
	unset -f nvm node npm npx
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
	nvm "$@"
}
node() { nvm; node "$@"; }
npm() { nvm; npm "$@"; }
npx() { nvm; npx "$@"; }
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(rbenv init -)"


# Created by `pipx` on 2024-03-17 07:20:24
export PATH="$PATH:/Users/omar/.local/bin"

# Added by Windsurf
export PATH="/Users/omar/.codeium/windsurf/bin:$PATH"

# add python to path
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

source "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/omar/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/omar/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/omar/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/omar/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#


. "$HOME/.atuin/bin/env"

# Atuin config - only bind to Ctrl+R
eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
bindkey '^r' _atuin_search_widget

# bun completions
[ -s "/Users/omar/.bun/_bun" ] && source "/Users/omar/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias workspace="cd ~/Documents/workspace"

setopt nobeep
