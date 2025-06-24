function git-clean-branches --description "Delete local branches that no longer exist on the remote"
    git fetch --prune
    git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
end
