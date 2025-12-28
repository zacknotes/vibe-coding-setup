#!/bin/bash

# Vibe Coding Setup Script for Mac
# Download this file, then run:
# xattr -d com.apple.quarantine ~/Downloads/setup-vibe-coding-mac.command && chmod +x ~/Downloads/setup-vibe-coding-mac.command && open ~/Downloads/setup-vibe-coding-mac.command

echo ""
echo "========================================"
echo "  Vibe Coding Setup - Sandbox Web"
echo "========================================"
echo ""
echo "This script will install:"
echo "  - Homebrew (if needed)"
echo "  - VS Code"
echo "  - Git"
echo "  - Node.js"
echo "  - Claude Code"
echo ""
echo "Grab a coffee - this takes about 5-10 minutes."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Track if we hit any errors
ERRORS=0

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================
# STEP 0: Install Homebrew (if needed)
# ============================================
echo -e "${GREEN}[0/4] Checking Homebrew...${NC}"

if command_exists brew; then
    echo -e "${GRAY}  Homebrew is already installed. Skipping.${NC}"
else
    echo -e "${GRAY}  Installing Homebrew (this takes a few minutes)...${NC}"
    echo -e "${YELLOW}  You may be prompted for your password.${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session (needed on Apple Silicon)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Also add to .zprofile for future sessions
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    # Verify it worked
    if command_exists brew; then
        echo -e "${GREEN}  Homebrew installed!${NC}"
    else
        echo -e "${RED}  ERROR: Homebrew installation failed.${NC}"
        echo -e "${RED}  Please try installing manually: https://brew.sh${NC}"
        ERRORS=1
    fi
fi

# Ensure brew is in PATH
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Check if brew is available before continuing
if ! command_exists brew; then
    echo -e "${RED}  Cannot continue without Homebrew. Exiting.${NC}"
    echo ""
    echo "Press Enter to close this window..."
    read
    exit 1
fi

# ============================================
# STEP 1: Install VS Code
# ============================================
echo -e "${GREEN}[1/4] Checking VS Code...${NC}"

if command_exists code; then
    echo -e "${GRAY}  VS Code is already installed. Skipping.${NC}"
elif [[ -d "/Applications/Visual Studio Code.app" ]]; then
    echo -e "${GRAY}  VS Code is installed but not in PATH. Adding...${NC}"
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
else
    echo -e "${GRAY}  Installing VS Code...${NC}"
    brew install --cask visual-studio-code
    
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        echo -e "${GREEN}  VS Code installed!${NC}"
    else
        echo -e "${RED}  ERROR: VS Code installation failed.${NC}"
        ERRORS=1
    fi
fi

# ============================================
# STEP 2: Install Git
# ============================================
echo -e "${GREEN}[2/4] Checking Git...${NC}"

if command_exists git; then
    echo -e "${GRAY}  Git is already installed. Skipping.${NC}"
else
    echo -e "${GRAY}  Installing Git...${NC}"
    brew install git
    
    if command_exists git; then
        echo -e "${GREEN}  Git installed!${NC}"
    else
        echo -e "${RED}  ERROR: Git installation failed.${NC}"
        ERRORS=1
    fi
fi

# ============================================
# STEP 3: Install Node.js
# ============================================
echo -e "${GREEN}[3/4] Checking Node.js...${NC}"

if command_exists node; then
    echo -e "${GRAY}  Node.js is already installed. Skipping.${NC}"
else
    echo -e "${GRAY}  Installing Node.js...${NC}"
    brew install node
    
    if command_exists node; then
        echo -e "${GREEN}  Node.js installed!${NC}"
    else
        echo -e "${RED}  ERROR: Node.js installation failed.${NC}"
        ERRORS=1
    fi
fi

# ============================================
# STEP 4: Install Claude Code
# ============================================
echo -e "${GREEN}[4/4] Installing Claude Code...${NC}"

if command_exists npm; then
    npm install -g @anthropic-ai/claude-code 2>/dev/null
    
    if command_exists claude; then
        echo -e "${GREEN}  Claude Code installed!${NC}"
    else
        echo -e "${YELLOW}  Claude Code installed (you may need to restart your terminal)${NC}"
    fi
else
    echo -e "${RED}  ERROR: npm not found. Cannot install Claude Code.${NC}"
    ERRORS=1
fi

# ============================================
# DONE - Launch VS Code
# ============================================
echo ""

if [[ $ERRORS -eq 0 ]]; then
    echo "========================================"
    echo -e "${CYAN}  Setup Complete!${NC}"
    echo "========================================"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. VS Code is about to open"
    echo "  2. Open the terminal: View > Terminal (or press Ctrl+\`)"
    echo "  3. Type: claude"
    echo "  4. Log in when the browser opens"
    echo "  5. Start vibing!"
    echo ""
    echo -e "${GREEN}Launching VS Code in 3 seconds...${NC}"
    sleep 3

    # Launch VS Code
    if [[ -d "/Applications/Visual Studio Code.app" ]]; then
        open -a "Visual Studio Code"
    elif command_exists code; then
        code
    fi

    echo ""
    echo -e "${CYAN}Happy vibe coding! - Sandbox Web${NC}"
else
    echo "========================================"
    echo -e "${RED}  Setup completed with errors${NC}"
    echo "========================================"
    echo ""
    echo "Some tools failed to install. Please check the errors above."
    echo "You can try running this script again, or install the failed tools manually."
    echo ""
    echo "For help, visit: https://www.sandboxweb.io/contact"
fi

echo ""
echo "Press Enter to close this window..."
read
