USER_LOCATION="Menlo Park, CA"

mktodo() {
    # Make a todo-list
    NEW_TODO="/local/todo/$(date -I)-TODO.md"
    OLD_TODO="/local/todo/$(date -I -d \"yesterday\")-TODO.md"
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

todo () {
    # Prints out your todolist for the day
    echo "---------------------------------------"
    echo "---- Your to-do list for the day: -----"
    echo "---------------------------------------"
    echo
    cat "/local/todo/$(date -I)-TODO.md"
    echo
}

welcome() {
    # Run this function on opening a new shell
    if [ -t 1 ]; then
        # Only proceed if STDOUT is a tty
        echo "---------------------------------------"
        if [ "$(date +%H)" -le 10 ]; then
            echo "-------  Good morning, $USER  ------"
        else
            echo "-------  Welcome back, $USER  ------"
        fi
        echo "---------------------------------------"
        echo
        TIME_INFO="$(date)"
        printf "Current time: %s\n" "$TIME_INFO"
        printf "Weather in %s:\n\n" "$USER_LOCATION"
        weather -lv
        echo
        if [ "$(date +%H)" -le 10 ]; then
            echo "---------------------------------------"
            echo "--- Information about this system: ----"
            echo "---------------------------------------"
            echo
            screenfetch
            echo
        fi
        todo
    fi
}
