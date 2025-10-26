# `dotfiles`

[Chezmoi](https://www.chezmoi.io/)-managed dotfiles for my systems.

## Installation

### 1. Install relevant software

Install any applicable software configured by this repo

### Terminal

- [chezmoi](https://www.chezmoi.io/)
- [fish](https://fishshell.com/)
- [starship](https://starship.rs/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [git-interactive-rebase-tool](https://github.com/MitMaro/git-interactive-rebase-tool/)
- [mise](https://mise.jdx.dev/)

### GUI

- [Ghostty](https://ghostty.org/)
- [VS Code](https://code.visualstudio.com/)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- [Rider](https://www.jetbrains.com/rider/)
- [Windsurf](https://windsurf.com/)
- [iTerm2](https://iterm2.com/)

### 2. Apply dotfiles

```bash
chezmoi init git@github.com:nint8835/dotfiles.git
chezmoi diff  # Confirm no undesired changes are being made
chezmoi apply
```

Note: ensure you have an SSH key configured for Git first. If not using SSH, swap the git URL for a HTTPS one.

### 3. Manual config

#### iTerm2

- In Preferences, navigate to General -> Preferences
- Enable "Load preferences from a custom folder or URL"
- Browse to `~/.config/iterm2`
- Restart iTerm2
