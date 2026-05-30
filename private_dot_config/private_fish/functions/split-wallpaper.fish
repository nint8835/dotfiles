function split-wallpaper \
    --description "Split an image into left and right halves and set them as dual-monitor wallpapers" \
    --argument-names file
    if test -z "$file"
        echo "Usage: split-wallpaper <image>" >&2
        return 1
    end

    if not command -q osascript
        echo "split-wallpaper: 'osascript' command not found; this function only works on macOS" >&2
        return 1
    end

    set -l images (split-image "$file")
    or return $status

    set -l left_image $images[1]
    set -l right_image $images[2]

    if test -z "$left_image"; or test -z "$right_image"
        echo "split-wallpaper: split-image did not return both output paths" >&2
        return 1
    end

    osascript -e "
        tell application \"System Events\"
            set picture of desktop 1 to POSIX file \"$left_image\"
            set picture of desktop 2 to POSIX file \"$right_image\"
        end tell
    "
end
