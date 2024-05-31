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
    declare -a SUPPORTED_FORMATS=("tar" "tarbz" "tarbz2" "targz" "tarlz" "tarlzo" "tarlzma" "tarxz" "tarlrz" "tarZ" "tar7z" "lz" "lrz" "rz""bz" "bz2" "xz" "lzo" "lzma" "gz" "7z" "rar" "zip" "zst" "Z" "zlib" "cpio" "ar" "jar" "war")
    # Extract the contents of a compressed file
    # Most common archive types are currently supported
    # Support for new types can be added using the "case" block below:
    if [[ -z "$1" ]] || [ "$1" = "--help" ]; then
        >&2 echo "extract() -- Decompress common archive formats with a single command."
        >&2 echo
        >&2 echo "Usage: extract foo.<filetype>"
        >&2 echo "Example: extract foo.tar.gz"
        >&2 echo
        >&2 echo "extract() supports the following archive types:"
        for formatname in "${SUPPORTED_FORMATS[@]}"; do
            >&2 printf "\t* .%s\n" "${formatname}"
        done
        return
    elif [[ -f "$1" ]]; then
        case "$1" in
            *.tar)        tar xvf "$1"                  ;;  # tar
            *.ustar)      tar xvf "$1"                  ;;  # tar
            *.tar.bz)     tar xvjf "$1"                 ;;  # tar + bzip(2)
            *.tbz)        tar xvjf "$1"                 ;;  # tar + bzip(2)
            *.tar.bz2)    tar xvjf "$1"                 ;;  # tar + bzip2
            *.tbz2)       tar xvjf "$1"                 ;;  # tar + bzip2
            *.tar.bzip)   tar xvjf "$1"                 ;;  # tar + bzip2
            *.tbzip)      tar xvjf "$1"                 ;;  # tar + bzip2
            *.tar.gz)     tar xvzf "$1"                 ;;  # tar + gzip
            *.tgz)        tar xvzf "$1"                 ;;  # tar + gzip
            *.tar.gzip)   tar xvzf "$1"                 ;;  # tar + gzip
            *.tgzip)      tar xvzf "$1"                 ;;  # tar + gzip
            *.tar.lz)     tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tlz)        tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tar.lzip)   tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tlzip)      tar --lzip -xvf "$1"          ;;  # tar + lzip
            *.tlzop)      tar --lzop -xvf "$1"          ;;  # tar + lzop
            *.tar.lzop)   tar --lzop -xvf "$1"          ;;  # tar + lzop
            *.tlzo)       tar --lzop -xvf "$1"          ;;  # tar + lzop
            *.tar.lzo)    tar --lzop -xvf "$1"          ;;  # tar + lzop
            *.tlzma)      tar --lzma -xvf "$1"          ;;  # tar + lzma (legacy)
            *.tar.lzma)   tar --lzma -xvf "$1"          ;;  # tar + lzma (legacy)
            *.tar.xz)     tar xvJf "$1"                 ;;  # tar + lmza2 (xz)
            *.txz)        tar xvJf "$1"                 ;;  # tar + lmza2 (xz)
            *.tar.Z)      zcat "$1" | tar xvf -         ;;  # tar + compress
            *.tZ)         zcat "$1" | tar xvf -         ;;  # tar + compress
            *.tar.lrz)    lrzuntar "$1"                 ;;  # tar + lrzip
            *.tlrz)       lrzuntar "$1"                 ;;  # tar + lrzip
            *.tar.lrzip)  lrzuntar "$1"                 ;;  # tar + lrzip
            *.tlrzip)     lrzuntar "$1"                 ;;  # tar + lrzip
            *.tar.7z)     7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.tar.7zip)   7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.t7z)        7z x -so "$1" | tar xF - -C . ;;  # tar + 7zip
            *.lrz)        lrunzip "$1"                  ;;  # lrzip
            *.lrzip)      lrunzip "$1"                  ;;  # lrzip
            *.rz)         runzip "$1"                   ;;  # rzip
            *.rzip)       runzip "$1"                   ;;  # rzip
            *.bz)         bunzip2 "$1"                  ;;  # bzip
            *.bzip)       bunzip2 "$1"                  ;;  # bzip
            *.bz2)        bunzip2 "$1"                  ;;  # bzip
            *.xz)         xz -d "$1"                    ;;  # xz-utils
            *.lzma)       xz --format=lzma -d "$1"      ;;  # lzma (xz-utils)
            *.lzop)       lzop -d "$1"                  ;;  # lzop
            *.lzo)        lzop -d "$1"                  ;;  # lzop
            *.gz)         gunzip "$1"                   ;;  # gzip
            *.gzip)       gunzip "$1"                   ;;  # gzip
            *.lz)         lzip -d -k "$1"               ;;  # lzip
            *.lzip)       lzip -d -k "$1"               ;;  # lzip
            *.7z)         7z x "$1"                     ;;  # 7zip
            *.7zip)       7z x "$1"                     ;;  # 7zip
            *.7z.+[0-9])  7z x "$1"                     ;;  # 7zip: format '.7z1'
            *.rar)        unrar x "$1"                  ;;  # rar
            *.rar+[0-9])  unrar x "$1"                  ;;  # rar: format '.rar1'
            *.zip)        unzip "$1"                    ;;  # zip
            *.zipx)       unzip "$1"                    ;;  # zip
            *.zstd)       unzstd "$1"                   ;;  # zstd (Zstandard)
            *.zst)        unzstd "$1"                   ;;  # zstd (Zstandard)
            *.Z)          uncompress "$1"               ;;  # compress
            *.zlib)       zlib-flate -uncompress "$1"   ;;  # zlib
            *.cpio)       cpio -idv "$1"                ;;  # cpio
            *.ar)         ar xv "$1"                    ;;  # ar
            *.jar)        jar xf "$1"                   ;;  # jar
            *.war)        jar xvf "$1"                  ;;  # war
            ###################################################################
            ### Everything has failed to be matched; unknown file extension ###
            ###################################################################
            *)
                >&2 echo "Encountered unknown type (${1##*.}) with file: $1"
                return 1
                ;;
        esac
    else
        >&2 echo "'$1', with filetype '${1##*.}', cannot be found."
        >&2 echo "Check if the file exists with:  stat '$1'"
        return 1
    fi
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

mcd() {
    # Make a new directory, then cd into it
    mkdir -p "$1"
    cd "$1" || exit 1
    pwd
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

fd_fsize() {
    # Find files by size
    if [ $# -eq 0 ]; then
        find . -size +4G
    else
        find . -size "$@"
    fi
}
