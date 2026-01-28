#!/bin/bash
#
# Figma to Code - Modern Installer
# One-liner: curl -fsSL https://raw.githubusercontent.com/blissito/figma-to-code/main/install.sh | bash
#

set -e

# Colors
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

# Spinner frames
SPINNER_FRAMES='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

# Banner
print_banner() {
  echo ""
  echo -e "${MAGENTA}${BOLD}"
  cat << 'EOF'
  _____ _                        _           ____          _
 |  ___(_) __ _ _ __ ___   __ _ | |_ ___    / ___|___   __| | ___
 | |_  | |/ _` | '_ ` _ \ / _` || __/ _ \  | |   / _ \ / _` |/ _ \
 |  _| | | (_| | | | | | | (_| || || (_) | | |__| (_) | (_| |  __/
 |_|   |_|\__, |_| |_| |_|\__,_| \__\___/   \____\___/ \__,_|\___|
          |___/
EOF
  echo -e "${NC}"
  echo -e "${DIM}  Pixel-perfect Figma to code, powered by Claude${NC}"
  echo ""
}

# Spinner function
spin() {
  local pid=$1
  local message=$2
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  local len=${#frames}

  # Hide cursor
  tput civis 2>/dev/null || true

  while kill -0 "$pid" 2>/dev/null; do
    local frame="${frames:$i:1}"
    printf "\r  ${CYAN}%s${NC} %s" "$frame" "$message"
    sleep 0.08
    i=$(( (i + 1) % len ))
  done

  # Show cursor
  tput cnorm 2>/dev/null || true

  # Wait for the process and get exit code
  wait "$pid" 2>/dev/null
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    printf "\r  ${GREEN}✓${NC} %s\n" "$message"
  else
    printf "\r  ${RED}✗${NC} %s\n" "$message"
  fi

  return $exit_code
}

# Run command with spinner
run_with_spinner() {
  local message=$1
  shift

  # Run command in background, redirect output
  "$@" > /tmp/ftc_install_output.log 2>&1 &
  local pid=$!

  spin "$pid" "$message"
  return $?
}

# Check mark
check() {
  echo -e "  ${GREEN}✓${NC} $1"
}

# Error mark
error() {
  echo -e "  ${RED}✗${NC} $1"
}

# Info
info() {
  echo -e "  ${CYAN}→${NC} $1"
}

# Warning
warn() {
  echo -e "  ${YELLOW}!${NC} $1"
}

# Print success box
print_success_box() {
  local chrome_url="https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"

  echo ""
  echo -e "${GREEN}┌─────────────────────────────────────────────────────────────┐${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}  ${GREEN}${BOLD}✓ figma-to-code installed successfully${NC}                    ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}  ${BOLD}Next steps:${NC}                                               ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}  ${CYAN}1.${NC} Install Chrome Extension ${DIM}(required)${NC}:                  ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}     ${DIM}${chrome_url}${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}  ${CYAN}2.${NC} Start Claude Code with Chrome:                          ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}     ${BOLD}claude --chrome${NC}                                         ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}  ${CYAN}3.${NC} Authenticate Figma MCP:                                 ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}     Type ${BOLD}/mcp${NC} → select ${BOLD}figma${NC} → complete OAuth              ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}  ${CYAN}4.${NC} Use the skill:                                          ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}     ${BOLD}/ftc${NC}                                                    ${GREEN}│${NC}"
  echo -e "${GREEN}│${NC}                                                             ${GREEN}│${NC}"
  echo -e "${GREEN}└─────────────────────────────────────────────────────────────┘${NC}"
  echo ""
}

# Check if Claude Code is installed
check_claude_code() {
  if ! command -v claude &> /dev/null; then
    error "Claude Code CLI not found"
    echo ""
    info "Install Claude Code first:"
    echo -e "     ${BOLD}npm install -g @anthropic-ai/claude-code${NC}"
    echo ""
    exit 1
  fi

  local version=$(claude --version 2>/dev/null | head -n1 || echo "unknown")
  check "Claude Code detected ${DIM}(${version})${NC}"
}

# Install plugin from marketplace
install_plugin() {
  # Check if already installed
  if claude plugin list 2>/dev/null | grep -q "figma-to-code"; then
    check "Plugin already installed"
    return 0
  fi

  run_with_spinner "Installing figma-to-code plugin..." claude plugin install marketplace:figma-to-code
}

# Configure Figma MCP
configure_figma_mcp() {
  # Check if already configured
  if claude mcp list 2>/dev/null | grep -q "figma"; then
    check "Figma MCP already configured"
    return 0
  fi

  run_with_spinner "Configuring Figma MCP..." claude mcp add --transport http figma https://mcp.figma.com/mcp
}

# Main installation flow
main() {
  print_banner

  echo -e "${BOLD}  Detecting environment...${NC}"
  echo ""

  # Step 1: Check Claude Code
  check_claude_code

  # Detect OS
  local os="unknown"
  case "$(uname -s)" in
    Darwin*) os="macOS" ;;
    Linux*)  os="Linux" ;;
    MINGW*|MSYS*|CYGWIN*) os="Windows" ;;
  esac
  check "Operating system: ${DIM}${os}${NC}"

  echo ""
  echo -e "${BOLD}  Installing components...${NC}"
  echo ""

  # Step 2: Install plugin
  install_plugin

  # Step 3: Configure Figma MCP
  configure_figma_mcp

  # Success!
  print_success_box
}

# Run main
main
