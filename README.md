# `dotfiles`

[Chezmoi](https://www.chezmoi.io/)-managed dotfiles for my systems.

## Installation

### 1. Install relevant software

Install any applicable software configured by this repo

### Terminal

- [chezmoi](https://www.chezmoi.io/)
- [fish](https://fishshell.com/)
- [fzf](https://github.com/junegunn/fzf)
- [git-interactive-rebase-tool](https://github.com/MitMaro/git-interactive-rebase-tool/)
- [mise](https://mise.jdx.dev/)
- [starship](https://starship.rs/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

### GUI

- [Ghostty](https://ghostty.org/)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- [Rider](https://www.jetbrains.com/rider/)
- [VS Code](https://code.visualstudio.com/)

### 2. Apply dotfiles

```bash
chezmoi init git@github.com:nint8835/dotfiles.git
chezmoi diff  # Confirm no undesired changes are being made
chezmoi apply
```

Note: ensure you have an SSH key configured for Git first. If not using SSH, swap the git URL for a HTTPS one.
