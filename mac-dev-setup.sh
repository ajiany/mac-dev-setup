#!/bin/bash

# Colors for better visualization
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
  echo -e "${BLUE}==>${NC} $1"
}

# Function to print success messages
print_success() {
  echo -e "${GREEN}==>${NC} $1"
}

# Function to print warning messages
print_warning() {
  echo -e "${YELLOW}==>${NC} $1"
}

# Function to print error messages
print_error() {
  echo -e "${RED}==>${NC} $1"
}

# Function to ask for confirmation
confirm() {
  read -p "$(echo -e "${YELLOW}==> $1 (y/n)${NC} ")" -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]]
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install a package with brew
install_with_brew() {
  if ! command_exists brew; then
    print_error "Homebrew is not installed. Installing it first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    if ! command_exists brew; then
      print_error "Failed to install Homebrew. Please install it manually."
      return 1
    fi
  fi
  
  if brew list "$1" &>/dev/null; then
    print_success "$1 is already installed"
    return 0
  fi
  
  if confirm "Install $1?"; then
    print_message "Installing $1..."
    if brew install "$1"; then
      print_success "$1 installed successfully"
      return 0
    else
      print_error "Failed to install $1"
      return 1
    fi
  else
    print_warning "Skipping $1 installation"
    return 1
  fi
}

# Function to install Go versions with mise
install_go_with_mise() {
  local version=$1
  
  if ! command_exists mise; then
    print_error "mise is not installed. Please install it first."
    return 1
  fi
  
  if mise list go | grep -q "$version"; then
    print_success "Go $version is already installed"
    return 0
  fi
  
  if confirm "Install Go $version?"; then
    print_message "Installing Go $version..."
    if mise install go@"$version"; then
      print_success "Go $version installed successfully"
      return 0
    else
      print_error "Failed to install Go $version"
      return 1
    fi
  else
    print_warning "Skipping Go $version installation"
    return 1
  fi
}

# Function to install a Mac application with brew
install_mac_app() {
  local app_name=$1
  local brew_name=$2
  
  if [[ -d "/Applications/${app_name}.app" ]] || [[ -d "${HOME}/Applications/${app_name}.app" ]]; then
    print_success "${app_name} is already installed"
    return 0
  fi
  
  if confirm "Install ${app_name}?"; then
    print_message "Installing ${app_name}..."
    if brew install --cask "${brew_name}"; then
      print_success "${app_name} installed successfully"
      return 0
    else
      print_error "Failed to install ${app_name}"
      return 1
    fi
  else
    print_warning "Skipping ${app_name} installation"
    return 1
  fi
}

# Main installation process
main() {
  print_message "Starting Mac development environment setup..."
  
  # Install zsh and related plugins
  install_with_brew "zsh"
  install_with_brew "zsh-autosuggestions"
  install_with_brew "zsh-syntax-highlighting"
  install_with_brew "zsh-completions"
  install_with_brew "autojump"
  
  # Install git
  install_with_brew "git"
  
  # Install mise for version management
  install_with_brew "mise"
  
  # Install Go versions with mise
  install_go_with_mise "1.18"
  install_go_with_mise "1.22"
  
  # Install miniconda
  install_with_brew "miniconda"
  
  # Install Mac applications
  install_mac_app "iTerm" "iterm2"
  install_mac_app "Google Chrome" "google-chrome"
  install_mac_app "Cursor" "cursor"
  
  print_message "Setup process completed!"
  
  # Configure zsh plugins
  if confirm "Configure zsh plugins in your .zshrc?"; then
    print_message "Configuring zsh plugins..."
    
    # Make sure .zshrc exists
    touch "${HOME}/.zshrc"
    
    # Add plugin configurations
    cat << 'EOF' >> "${HOME}/.zshrc"

# ZSH Plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-completions/zsh-completions.zsh
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

# Mise setup
eval "$(mise activate zsh)"

# Miniconda setup
eval "$($(brew --prefix)/Caskroom/miniconda/base/bin/conda shell.zsh hook)"
EOF
    
    print_success "ZSH plugins configured in .zshrc"
  fi
  
  # Final instructions
  print_message "To apply all changes, please restart your terminal or run: source ~/.zshrc"
  
  # Set default Go version
  if command_exists mise && confirm "Set Go 1.22 as your default Go version?"; then
    mise use --global go@1.22
    print_success "Go 1.22 set as default"
  fi
}

main 