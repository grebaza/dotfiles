set_session_dbus()
{
    local bus_file_path="$XDG_RUNTIME_DIR/bus"

    export DBUS_SESSION_BUS_ADDRESS=unix:path=$bus_file_path
    if [ ! -e "$bus_file_path" ]; then
    {
        /usr/bin/dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &

        # --------------------
        # More background processes can be added here.
        # For 'sudo' requiring commands, you should add them above
        # where the 'dbus' service is started.
        # --------------------

    }
    fi
}
