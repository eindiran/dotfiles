#!/usr/bin/env bash
#===============================================================================
#
#          FILE: .tts_utils.sh
#
#   DESCRIPTION: Support calling out to TTS functionality via pico2wave and
#                espeak. pico2wave for raw English; espeak for IPA strings.
#
#  REQUIREMENTS: pico2wave (available from the libttspico-utils package on
#                           Debian-based distros)
#                espeak (available from the espeak package)
#                Either sox or aplay for WAV file playback
#         NOTES: Source this file in the rc file of your preferred shell.
#        AUTHOR: Elliott Indiran <eindiran@uchicago.edu>
#===============================================================================

TTS_LANG=en-US
WAV_PLAYER=sox
# To use aplay instead:
# WAV_PLAYER=aplay

_play_tts_file_sox() {
    # This fudges around with the treble and gain to get the
    # output of pico2wave to sound more natural
    # Uses quiet-level verbosity to suppress printing to stdout
    # Not intended to be called directly by a user
    play -qV0 "$1" treble 20 gain -l 3
}

_play_tts_file_aplay() {
    # Use quiet to suppress printing to stdout
    # Not intended to be called directly by a user
    aplay -P -q -t wav "$1"
}

_play_tts_file() {
    # Play a generated TTS WAV file
    # Not intended to be called directly by a user
    if [ "$WAV_PLAYER" == "aplay" ]; then
        _play_tts_file_aplay "$1"
    elif [ "$WAV_PLAYER" == "sox" ]; then
        _play_tts_file_sox "$1"
    else
        printf "Using %s to play WAV files" "$WAV_PLAYER"
        $WAV_PLAYER "$1"
    fi
}

play_tfile() {
    # Play the contents of a text file aloud via pico2wave
    TMP_WAV_FILE=$(mktemp /tmp/play_tfile.XXXXXX.wav)
    pico2wave -l="$TTS_LANG" -w="$TMP_WAV_FILE" "$(cat "$1")"
    _play_tts_file "$TMP_WAV_FILE"
    rm -f "$TMP_WAV_FILE" > /dev/null
}

play_tstr() {
    # Play a string aloud via pico2wave
    TMP_WAV_FILE=$(mktemp /tmp/play_tfile.XXXXXX.wav)
    pico2wave -l="$TTS_LANG" -w="$TMP_WAV_FILE" "$@"
    _play_tts_file "$TMP_WAV_FILE"
    rm -f "$TMP_WAV_FILE" > /dev/null
}

play_ipa_file() {
    # Play an ASCII IPA file aloud via espeak
    TMP_WAV_FILE=$(mktemp /tmp/play_tfile.XXXXXX.wav)
    espeak -b1 -w "$TMP_WAV_FILE" -f "$1"
    _play_tts_file "$TMP_WAV_FILE"
    rm -f "$TMP_WAV_FILE" > /dev/null
}

play_ipa_str() {
    # Play an ASCII IPA string aloud via espeak
    TMP_WAV_FILE=$(mktemp /tmp/play_tfile.XXXXXX.wav)
    espeak -b1 -w "$TMP_WAV_FILE" "$@"
    _play_tts_file "$TMP_WAV_FILE"
    rm -f "$TMP_WAV_FILE" > /dev/null
}
