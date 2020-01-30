#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .file_utils.sh
# 
#         USAGE: Source this file in your shell's rc file.
# 
#   DESCRIPTION: Add utility functions that handle files to the shell.
# 
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
#===============================================================================

extract() {
    # Extract the contents of a compressed file
    # Most common archive types are currently supported
    # Support for new types can be added using the "case" block below:
    if [ "$1" = "--help" ] ; then
        echo "extract() -- Decompress all common archive formats with a single command."
        echo
        echo "Usage: extract foo.<filetype>"
        echo "Example: extract foo.tar.gz"
        echo
        echo "extract() supports the following filetypes:"
        printf "\t\t.tar\n\t\t.tar.bz2\n\t\t.tar.bz\n\t\t.tar.gz\n\t\t.tar.lz\n\t\t.tar.xz\n"
        printf "\t\t.tar.Z\n\t\t.tar.lrz\n\t\t.lrz\n\t\t.tar.7z\n\t\t.rz\n\t\t.bz2\n\t\t.bz\n\t\t.xz\n"
        printf "\t\t.lz\n\t\t.rar\n\t\t.gz\n\t\t.zip\n\t\t.Z\n\t\t.7z\n\t\t.zlib\n"
        return
    elif [ -f "$1" ] ; then
        case "$1" in
            *.tar)       tar xvf "$1"                  ;;  # tar
            *.tar.bz)    tar xvjf "$1"                 ;;  # tar + bzip(2)
            *.tbz)       tar xvjf "$1"                 ;;  # tar + bzip(2)
            *.tar.bz2)   tar xvjf "$1"                 ;;  # tar + bzip2
            *.tbz2)      tar xvjf "$1"                 ;;  # tar + bzip2
            *.tar.gz)    tar xvzf "$1"                 ;;  # tar + gzip
            *.tgz)       tar xvzf "$1"                 ;;  # tar + gzip
            *.tar.lz)    tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tlz)       tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tar.xz)    tar xvJf "$1"                 ;;  # tar + lmza/lmza2
            *.txz)       tar xvJf "$1"                 ;;  # tar + lmza/lmza2
            *.tar.Z)     zcat "$1" | tar xvf -         ;;  # tar + compress
            *.tZ)        zcat "$1" | tar xvf -         ;;  # tar + compress
            *.tar.lrz)   lrzuntar "$1"                 ;;  # tar + lrzip
            *.tlrz)      lrzuntar "$1"                 ;;  # tar + lrzip
            *.tar.7z)    7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.tar.7zip)  7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.t7z)       7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.lrz)       lrunzip "$1"                  ;;  # lrzip
            *.rz)        runzip "$1"                   ;;  # rzip
            *.bz)        bunzip2 "$1"                  ;;  # bzip
            *.bz2)       bunzip2 "$1"                  ;;  # bzip
            *.xz)        xz -d "$1"                    ;;  # xz-utils
            *.gz)        gunzip "$1"                   ;;  # gzip
            *.lz)        lzip -d -k "$1"               ;;  # lzip
            *.7z)        7z x "$1"                     ;;  # 7zip
            *.7zip)      7z x "$1"                     ;;  # 7zip
            *.7z.+[0-9]) 7z x "$1"                     ;;  # 7zip: format '.7z1'
            *.rar)       unrar x "$1"                  ;;  # rar
            *.rar+[0-9]) unrar x "$1"                  ;;  # rar: format '.rar1'
            *.zip)       unzip "$1"                    ;;  # zip
            *.Z)         uncompress "$1"               ;;  # compress
            *.zlib)      zlib-flate -uncompress "$1"   ;;  # zlib
            ###################################################################
            ### Everything has failed to be matched; unknown file extension ###
            ###################################################################
            *)           echo "Encountered unknown type (${1##*.}) with file: $1" ;;
        esac
    else
        echo "'$1', with filetype '${1##*.}', is not a valid file!"
        echo "Check if the file exists with:  stat '$1'"
    fi
}

chmodr() {
    # Change the permissions of a file to allow it to be readable by everyone
    chmod a+r $@
}

chmodw() {
    # Change the permissions of a file to allow it to be writeable by everyone
    chmod a+w $@
}

chmodx() {
    # Change the permissions of a file to allow it to be executable by everyone
    chmod a+x $@
}

chmoda() {
    # Change the permissions of a file to allow it to be readable, writeable,
    # and executable by everyone. Equivalent to `chmod 777 $@`
    chmod 777 $@
}

chmodnr() {
    # Change the permissions of a file to remove all read permissions
    chmod a-r $@
}

chmodnw() {
    # Change the permissions of a file to remove all write permissions
    chmod a-w $@
}

chmodnx() {
    # Change the permissions of a file to remove all execute permissions
    chmod a-x $@
}

targz() {
    # Tar and gzip a file or set of files
    tar -zcvf "$1.tar.gz" "$1"
}

tarbz() {
    # Tar and bzip a file or set of files
    tar -jcvf "$1.tar.bz2" "$1"
}

tarz() {
    # Tar and compress (.Z) a file or set of files
    tar -c "$@" | compress > "$1.tar.Z"
}

tarxz() {
    # Tar and xz a file or set of files
    tar -c "$@" | xz > "$1.tar.xz"
}

tarlz() {
    # Tar and lz a file or set of files
    tar -c "$@" | lzip -9 > "$1.tar.lz"
}

tarlrz() {
    # Tar and lrzip a file or set of files
    tar -c "$@" | lrzip > "$1.tar.lrz"
}

tar7z() {
    # Tar and 7zip a file or set of files
    tar -c "$@" | 7z > "$1.tar.7z"
}

ljar() {
    # List the contents of a JAR file
    jar tvf "$@"
}

batch_ext_rename() {
    # Batch rename files from one extension to another
    for file in *.$1
    do
        mv "$file" "${file%.$1}.$2"
    done
}

mcd() {
    # Make a new directory, then cd into it
    mkdir -p "$1"
    cd "$1" || exit 1
    pwd
}

set_dir_permissions() {
    # Sets ideal directory permissions
    find . -type d -exec chmod 755 {} \;
}

hidden() {
    # Finds hidden files recursively in current directory
    # Handle no argument case
    if [ $# -eq 0 ] ; then
        ls -l -d .[!.]?*
        return
    fi
    DIR_TO_SEARCH="$1"
    shift
    # Handle first argument
    case "$DIR_TO_SEARCH" in
        -h|--help)
            echo "Usage: hidden <dir> [-d|-f|-r]"
            return
            ;;
        *)
            if [ ! -d "$DIR_TO_SEARCH" ] ; then
                printf "%s is not a directory.\n" "$DIR_TO_SEARCH"
                return
            fi
            ;;
    esac
    # Handle optional second argument
    if [ $# -gt 0 ] ; then
        ARGUMENT="$1"
        case "$ARGUMENT" in
            -d|--dirs)
                find "$DIR_TO_SEARCH" -type d -iname ".*" -ls
                ;;
            -f|--files)
                find "$DIR_TO_SEARCH" -type f -iname ".*" -ls
                ;;
            -r|--recursive)
                find "$DIR_TO_SEARCH" -name ".*" -ls
                ;;
            *)
                echo "Unknown option: hidden <dir> [-d|-f|-r]"
                ;;
        esac
    fi
}

clean_perl() {
    # Cleans untidy or obfuscated perl code
    perl -MO=Deparse "$1" | perltidy -ce -i=4 -st
}

jpg_to_png() {
    # Converts files in dir/subdirs from jpg to png
    find . -name "*.jpg" -exec mogrify -format png {} \;
}

png_to_jpg() {
    # Converts files in dir/subdirs from png to jpg
    find . -name "*.png" -exec mogrify -format jpg {} \;
}

transparent_png_to_jpg() {
    # Converts transparent background png files to jpg files
    find . -name "*.png" -exec mogrify -format jpg -background black -flatten {} \;
}

svg_to_png() {
    # Converts svg files to png
    for file in *.svg; do
        svgexport "${file}" "${file/svg/png}" 1024:1024
    done
}

svg_to_jpg() {
    # Converts svg files to jpg
    for file in *.svg; do
        svgexport "${file}" "${file/svg/jpg}" --format jpg
    done
}
