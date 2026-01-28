#!/bin/bash
#
# Figma to Code - Modern Installer
# One-liner: curl -fsSL https://raw.githubusercontent.com/blissito/figma-to-code/main/install.sh | bash
# English:   curl -fsSL https://raw.githubusercontent.com/blissito/figma-to-code/main/install.sh | bash -s -- --en
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

# Default language: Spanish
LANG_EN=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --en|--english)
      LANG_EN=true
      shift
      ;;
  esac
done

# i18n messages
if [ "$LANG_EN" = true ]; then
  MSG_TAGLINE="Pixel-perfect Figma to code, powered by Claude"
  MSG_DETECTING="Detecting environment..."
  MSG_CLAUDE_DETECTED="Claude Code detected"
  MSG_CLAUDE_NOT_FOUND="Claude Code CLI not found"
  MSG_INSTALL_CLAUDE="Install Claude Code first:"
  MSG_OS="Operating system"
  MSG_INSTALLING="Installing components..."
  MSG_PLUGIN_INSTALLED="Plugin already installed"
  MSG_INSTALLING_PLUGIN="Installing figma-to-code plugin..."
  MSG_MCP_CONFIGURED="Figma MCP already configured"
  MSG_CONFIGURING_MCP="Configuring Figma MCP..."
  MSG_SUCCESS="figma-to-code installed successfully"
  MSG_CHROME_REQUIRED="Chrome Extension required"
  MSG_CHROME_HINT="If not installed, get it here:"
  MSG_LAUNCHING="Launching Claude..."
  MSG_STARTING="Starting claude --chrome with /ftc skill"
  MSG_FIRST_TIME="First time? Complete Figma OAuth when prompted"
else
  MSG_TAGLINE="Figma a código pixel-perfect, powered by Claude"
  MSG_DETECTING="Detectando entorno..."
  MSG_CLAUDE_DETECTED="Claude Code detectado"
  MSG_CLAUDE_NOT_FOUND="Claude Code CLI no encontrado"
  MSG_INSTALL_CLAUDE="Instala Claude Code primero:"
  MSG_OS="Sistema operativo"
  MSG_INSTALLING="Instalando componentes..."
  MSG_PLUGIN_INSTALLED="Plugin ya instalado"
  MSG_INSTALLING_PLUGIN="Instalando plugin figma-to-code..."
  MSG_MCP_CONFIGURED="Figma MCP ya configurado"
  MSG_CONFIGURING_MCP="Configurando Figma MCP..."
  MSG_SUCCESS="figma-to-code instalado correctamente"
  MSG_CHROME_REQUIRED="Extensión de Chrome requerida"
  MSG_CHROME_HINT="Si no la tienes, descárgala aquí:"
  MSG_LAUNCHING="Iniciando Claude..."
  MSG_STARTING="Iniciando claude --chrome con skill /ftc"
  MSG_FIRST_TIME="¿Primera vez? Completa OAuth de Figma cuando aparezca"
fi

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
  echo -e "${DIM}  ${MSG_TAGLINE}${NC}"
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

# Print success message
print_success() {
  echo ""
  echo -e "  ${GREEN}${BOLD}✓ ${MSG_SUCCESS}${NC}"
  echo ""
}

# Check Chrome Extension requirement
check_chrome_extension() {
  local chrome_url="https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"

  echo -e "${BOLD}  ${MSG_CHROME_REQUIRED}${NC}"
  echo ""
  echo -e "  ${DIM}${MSG_CHROME_HINT}${NC}"
  echo -e "  ${CYAN}${chrome_url}${NC}"
  echo ""
}

# Launch Claude with Chrome and /ftc
launch_claude() {
  echo -e "${BOLD}  ${MSG_LAUNCHING}${NC}"
  echo ""
  echo -e "  ${DIM}${MSG_STARTING}${NC}"
  echo -e "  ${DIM}${MSG_FIRST_TIME}${NC}"
  echo ""

  # Small delay so user can read
  sleep 1

  # Replace this process with claude (full auto mode)
  exec claude --chrome --dangerously-skip-permissions -p "/ftc"
}

# Check if Claude Code is installed
check_claude_code() {
  if ! command -v claude &> /dev/null; then
    error "$MSG_CLAUDE_NOT_FOUND"
    echo ""
    info "$MSG_INSTALL_CLAUDE"
    echo -e "     ${BOLD}npm install -g @anthropic-ai/claude-code${NC}"
    echo ""
    exit 1
  fi

  local version=$(claude --version 2>/dev/null | head -n1 || echo "unknown")
  check "${MSG_CLAUDE_DETECTED} ${DIM}(${version})${NC}"
}

# Install plugin from marketplace
install_plugin() {
  # Check if already installed
  if claude plugin list 2>/dev/null | grep -q "figma-to-code"; then
    check "$MSG_PLUGIN_INSTALLED"
    return 0
  fi

  run_with_spinner "$MSG_INSTALLING_PLUGIN" claude plugin install marketplace:figma-to-code
}

# Configure Figma MCP
configure_figma_mcp() {
  # Check if already configured
  if claude mcp list 2>/dev/null | grep -q "figma"; then
    check "$MSG_MCP_CONFIGURED"
    return 0
  fi

  run_with_spinner "$MSG_CONFIGURING_MCP" claude mcp add --transport http figma https://mcp.figma.com/mcp
}

# Main installation flow
main() {
  print_banner

  echo -e "${BOLD}  ${MSG_DETECTING}${NC}"
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
  check "${MSG_OS}: ${DIM}${os}${NC}"

  echo ""
  echo -e "${BOLD}  ${MSG_INSTALLING}${NC}"
  echo ""

  # Step 2: Install plugin
  install_plugin

  # Step 3: Configure Figma MCP
  configure_figma_mcp

  # Success message
  print_success

  # Chrome extension info
  check_chrome_extension

  # Launch Claude with /ftc
  launch_claude
}

# Run main
main
