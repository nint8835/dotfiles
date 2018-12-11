git clone --bare https://github.com/nint8835/dotfiles.git %USERPROFILE%/.dotfiles
git --git-dir=%USERPROFILE%/.dotfiles/ --work-tree=%USERPROFILE% checkout -f
git --git-dir=%USERPROFILE%/.dotfiles/ --work-tree=%USERPROFILE% config --local status.showUntrackedFiles no
