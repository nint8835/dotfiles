# `dotfiles`

[Chezmoi](https://www.chezmoi.io/)-managed dotfiles for my systems.

## Installation

### 1. Install dependencies

_TODO_

### 2. Apply dotfiles

```bash
chezmoi init git@github.com:nint8835/dotfiles.git
chezmoi diff  # Confirm no undesired changes are being made
chezmoi apply
```

### 3. Manual config

#### iTerm2

- In Preferences, navigate to General -> Preferences
- Enable "Load preferences from a custom folder or URL"
- Browse to `~/.config/iterm2`
- Restart iTerm2
