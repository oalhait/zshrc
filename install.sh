#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing zshrc dependencies..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install zsh-completions via Homebrew
echo "Installing zsh-completions..."
brew install zsh-completions 2>/dev/null || echo "zsh-completions already installed"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Install zsh-syntax-highlighting plugin
ZSH_SYNTAX_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_SYNTAX_DIR" ]; then
    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
else
    echo "zsh-syntax-highlighting already installed"
fi

# Install gitster theme if not present
GITSTER_THEME="$HOME/.oh-my-zsh/custom/themes/gitster.zsh-theme"
if [ ! -f "$GITSTER_THEME" ]; then
    echo "Installing gitster theme..."
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    curl -fsSL https://raw.githubusercontent.com/shashankmehta/dotfiles/master/thesetup/zsh/.oh-my-zsh/custom/themes/gitster.zsh-theme -o "$GITSTER_THEME"
else
    echo "gitster theme already installed"
fi

# Backup existing .zshrc if it exists and is not a symlink
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Create symlink to zshrc
echo "Symlinking zshrc..."
ln -sf "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"

# Create empty wifi.sh if it doesn't exist (referenced in zshrc)
if [ ! -f "$HOME/wifi.sh" ]; then
    echo "Creating empty wifi.sh placeholder..."
    touch "$HOME/wifi.sh"
fi

echo ""
echo "Installation complete!"
echo "Please restart your terminal or run: source ~/.zshrc"
