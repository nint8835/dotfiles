function split-image \
    --description "Split an image into left and right halves" \
    --argument-names file
    if test -z "$file"
        echo "Usage: split-image <image>" >&2
        return 1
    end

    if not command -q magick
        echo "split-image: ImageMagick 'magick' command not found" >&2
        return 1
    end

    set -l file (path resolve "$file")

    if not test -f "$file"
        echo "split-image: file not found: $file" >&2
        return 1
    end

    set -l dir (path dirname "$file")
    set -l extension (path extension "$file")
    set -l name_no_extension (path change-extension '' (path basename "$file"))

    set -l left_image "$dir/$name_no_extension"_left"$extension"
    set -l right_image "$dir/$name_no_extension"_right"$extension"

    magick "$file" -gravity West -crop 50%x100%+0+0 +repage "$left_image"
    or return $status

    magick "$file" -gravity East -crop 50%x100%+0+0 +repage "$right_image"
    or return $status

    echo "$left_image"
    echo "$right_image"
end
