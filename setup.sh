#!/usr/bin/env bash
#
# ClaudeAgentConfig setup script
# Creates symlinks from the Xcode agent config directory to this repo
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XCODE_AGENT_DIR="$HOME/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig"

success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

link() {
    local source="$1"
    local target="$2"
    local name
    name=$(basename "$target")

    if [[ -L "$target" ]]; then
        local current
        current=$(readlink "$target")
        if [[ "$current" == "$source" ]]; then
            success "$name already linked"
            return
        fi
        warn "$name symlink exists but points to $current — replacing"
        rm "$target"
    elif [[ -e "$target" ]]; then
        warn "$name exists as a regular file/directory — backing up to ${name}.bak"
        mv "$target" "${target}.bak"
    fi

    ln -s "$source" "$target"
    success "$name linked → $source"
}

verify() {
    local failed=0

    for item in CLAUDE.md skills; do
        local target="$XCODE_AGENT_DIR/$item"
        if [[ -L "$target" ]]; then
            local dest
            dest=$(readlink "$target")
            if [[ -e "$dest" ]]; then
                success "$item → $dest"
            else
                warn "$item symlink is broken → $dest"
                failed=1
            fi
        elif [[ -e "$target" ]]; then
            warn "$item exists but is not a symlink"
            failed=1
        else
            warn "$item missing"
            failed=1
        fi
    done

    return $failed
}

case "${1:-}" in
    --help|-h)
        echo "Usage: ./setup.sh [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h    Show this help message"
        echo "  --verify      Check symlinks without modifying anything"
        echo "  (no args)     Create symlinks to Xcode agent config directory"
        ;;
    --verify)
        verify
        ;;
    *)
        if [[ ! -d "$XCODE_AGENT_DIR" ]]; then
            mkdir -p "$XCODE_AGENT_DIR"
            success "Created $XCODE_AGENT_DIR"
        fi

        link "$REPO_DIR/xcode-agent/CLAUDE.md" "$XCODE_AGENT_DIR/CLAUDE.md"
        link "$REPO_DIR/xcode-agent/skills" "$XCODE_AGENT_DIR/skills"

        echo ""
        verify
        ;;
esac
