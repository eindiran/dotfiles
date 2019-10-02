#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .tts_utils.sh
#
#   DESCRIPTION: Support calling out to TTS functionality via pico2wave.
#
#  REQUIREMENTS: pico2wave (available from the libttspico-utils package on
#                           Debian-based distros)
#                Either sox or aplay for WAV file playback
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <eindiran@uchicago.edu>
#===============================================================================

TTS_LANG=en-US
WAV_PLAYER=sox
# To use aplay instead:
# WAV_PLAYER=aplay

play_tts_file_sox() {
    # This fudges around with the treble and gain to get the
    # output of pico2wave to sound more natural
    play -qV0 "$1" treble 20 gain -l 3
}

play_tts_file_aplay() {
    aplay -P -q -t wav "$1"
}

play_tfile() {
    # Play the contents of a text file aloud via pico2wave
    TMP_WAV_FILE=$(mktemp /tmp/play_tfile.XXXXXX.wav)
    pico2wave -l="$TTS_LANG" -w="$TMP_WAV_FILE" "$(cat "$1")"
    if [ "$WAV_PLAYER" == "aplay" ]; then
        play_tts_file_aplay "$TMP_WAV_FILE"
    elif [ "$WAV_PLAYER" == "sox" ]; then
        play_tts_file_sox "$TMP_WAV_FILE"
    else
        printf "Using %s to play WAV files" "$WAV_PLAYER"
        $WAV_PLAYER "$TMP_WAV_FILE"
    fi
    rm -f "$TMP_WAV_FILE" > /dev/null
}

play_tstr() {
    # Play a string aloud via pico2wave
    TMP_WAV_FILE=$(mktemp /tmp/play_tfile.XXXXXX.wav)
    pico2wave -l="$TTS_LANG" -w="$TMP_WAV_FILE" "$@"
    if [ "$WAV_PLAYER" == "aplay" ]; then
        play_tts_file_aplay "$TMP_WAV_FILE"
    elif [ "$WAV_PLAYER" == "sox" ]; then
        play_tts_file_sox "$TMP_WAV_FILE"
    else
        printf "Using %s to play WAV files" "$WAV_PLAYER"
        $WAV_PLAYER "$TMP_WAV_FILE"
    fi
    rm -f "$TMP_WAV_FILE" > /dev/null
}
