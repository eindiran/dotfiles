source ~/.shell_utils.sh

# Configure by user
USER_LOCATION="Menlo Park, CA"

# Horrible terminal color codes
RED_TC='\033[0;31m' # Red
BLU_TC='\033[0;34m' # Blue
BLK_TC='\033[0;30m' # Black
WHT_TC='\033[0;37m' # White
CLR_TC='\033[0m'    # No color; used to reset

mktodo() {
    # Make a todo list
    NEW_TODO="/local/todo/$(date -I)-TODO.md"
    OLD_TODO="/local/todo/$(date -I -d "yesterday")-TODO.md"
    if [ -f "$NEW_TODO" ] ; then
        echo "To-do list for today already exists."
    elif [ ! -f "$OLD_TODO" ] ; then
        touch "$NEW_TODO"
        echo "Created blank todo list: $NEW_TODO"
    else
        echo "Creating new todo list using yesterday's todo list."
        grep -v "DONE" "$OLD_TODO" > "$NEW_TODO"
        echo "Here is the todo list: $NEW_TODO"
    fi
}

todo() {
    # Prints out your todo list for the day
    echo "${BLU_TC}---------------------------------------"
    echo "----- ${WHT_TC}Your todo list for the day: ${BLU_TC}-----"
    echo "---------------------------------------${CLR_TC}"
    echo
    TODO_FILE="/local/todo/$(date -I)-TODO.md"
    while IFS= read -r line; do
        if beginswith "#" "$line"; then
            echo "${RED_TC}$line${CLR_TC}"
        elif beginswith "* " "$line"; then
            echo "${BLU_TC}* ${CLR_TC}${line#* }"
        else
            echo "$line"
        fi
    done < "$TODO_FILE"
    echo
}

todoe() {
    # Opens your todo list for edit
    vim "/local/todo/$(date -I)-TODO.md"
}

agenda() {
    # Shows your agenda for the day
    echo "${BLU_TC}---------------------------------------"
    echo "----- ${WHT_TC}Your agenda for the day: ${BLU_TC}-----"
    echo "---------------------------------------${CLR_TC}"
    echo
    gcalcli agenda | head -n 10
}

welcome() {
    # Run this function on opening a new shell
    if [ -t 1 ]; then
        # Only proceed if STDOUT is a tty
        echo "${BLU_TC}---------------------------------------"
        if [ "$(date +%H)" -le 10 ]; then
            echo "-------${WHT_TC}  Good morning, $USER  ${BLU_TC}------"
        else
            echo "-------${WHT_TC}  Welcome back, $USER  ${BLU_TC}------"
        fi
        echo "---------------------------------------${CLR_TC}"
        echo
        TIME_INFO="$(date)"
        printf "Current time: ${WHT_TC}%s${CLR_TC}\n" "$TIME_INFO"
        printf "Weather in ${WHT_TC}%s${CLR_TC}:\n\n" "$USER_LOCATION"
        weather -lv
        echo
        TODO_FILE="/local/todo/$(date -I)-TODO.md"
        if [ -f "$TODO_FILE" ] ; then
            todo
        else
            mktodo > /dev/null
            todo
        fi
        echo
        agenda
    fi
}

mwelcome() {
    (echo "${BLU_TC}---------------------------------------"
    if [ "$(date +%H)" -le 10 ]; then
        echo "-------${WHT_TC}  Good morning, $USER  ${BLU_TC}------"
    else
        echo "-------${WHT_TC}  Welcome back, $USER  ${BLU_TC}------"
    fi
    echo "---------------------------------------${CLR_TC}"
    echo
    TIME_INFO="$(date)"
    printf "Current time: ${WHT_TC}%s${CLR_TC}\n" "$TIME_INFO"
    printf "Weather in ${WHT_TC}%s${CLR_TC}:\n\n" "$USER_LOCATION"
    weather -lv
    TODO_FILE="/local/todo/$(date -I)-TODO.md"
    if [ -f "$TODO_FILE" ] ; then
        todo
    else
        mktodo > /dev/null
        todo
    fi
    echo
    agenda) | more
}
