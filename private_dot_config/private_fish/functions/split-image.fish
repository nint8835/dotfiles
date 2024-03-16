function split-image --description "Split an image in half horizontally"
    set file $argv[1]

    set extension (path extension $file)
    set name_no_extension (basename $file $extension)

    magick $file -crop 50%x100% +repage "$name_no_extension"_split_%d"$extension"
end
