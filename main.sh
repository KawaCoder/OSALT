#!/bin/bash

# OSALT: Open Source Scripting Automation Linux Toolkit

# Copyright (c) 2023 KawaCoder@duck.com
#
# This program is free software: you can redistribute it and/or modify it under 
# the terms of the GNU General Public License as published by the Free Software 
# Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <https://www.gnu.org/licenses/>. *
#
    
function show_help() {
    echo "osalt [options] [script_name]"
    echo
    echo "Options:"
    echo "  -s, --startup <script_name>                Add a startup script."
    echo "  -w, --shutdown <script_name>               Add a shutdown script."
    echo "  -c, --scheduled <script_name> <scheduled>  Add a scheduled script."
    echo "  -d, --delete <script_name>                 Delete a script."
    echo "  -l, --list                                 List all available scripts."
    echo "  -h, --help                                 Prints this help."
    echo
    echo "Examples:"
    echo "  osalt -s my_startup_script.sh"
    echo "  osalt -h my_shutdown_script.sh"
    echo "  osalt -c my_scheduled_script.sh \"*-*-* 9-17:00:00\""
    echo "  osalt -v my_startup_script.sh"
    echo "  osalt -d my_shutdown_script.sh"
    echo "  osalt -l"

}

function list_scripts(){

    # Parse the config.json file with jq
    config_file="config.json"

    # List items in the "startup" category
    echo "Startup:"
    jq -r '.startup[] | .name' "$config_file"

    # List items in the "shutdown" category
    echo "Shutdown:"
    jq -r '.shutdown[] | .name' "$config_file"

    # List items in the "scheduled" category
    echo "Scheduled:"
    jq -r '.scheduled[] | .name' "$config_file"


}

function delete_script() {
    script_name="$1"
    just_file_name="$(basename "$script_name" ".sh")"
    config_file="config.json"

#    if [ -f "config.json" ]; then
#        script_category=""
#        if [ "$(jq -r ".startup | index( \"$script_name\" )" "$config_file")" != null ]; then
#            script_category="startup"
#        elif [ "$(jq -r ".shutdown | index( \"$script_name\" )" "$config_file")" != null ]; then
#            script_category="shutdown"
#        elif [ "$(jq -r ".scheduled | index( \"$script_name\" )" "$config_file")" != null ]; then
#            script_category="scheduled"
#        else
#            echo "Script \"$script_name\" not found in config.json"
#            exit 1
#        fi
        script_category=$(jq -r '
  if .startup[] | select(.name == "test.sh") then
    "startup"
  else
    "startup not found"
  end,
  if .shutdown[] | select(.name == "test.sh") then
    "shutdown"
  else
    "shutdown not found"
  end,
  if .scheduled[] | select(.name == "test.sh") then
    "scheduled"
  else
    "scheduled not found"
  end' config.json)

        jq --arg script_name "$script_name" 'del(.startup[] | select(.name == $script_name)) | del(.shutdown[] | select(.name == $script_name)) | del(.scheduled[] | select(.name == $script_name))' "config.json" > temp.json

        mv temp.json "$config_file"

        if [ -f "$HOME/OSALT/scripts/$script_category/$script_name" ]; then
            rm "$HOME/OSALT/scripts/$script_category/$script_name"
        else
            echo "Script file not found in \"$HOME/OSALT/scripts/$script_category/\""
        fi

        echo "Script \"$script_name\" has been deleted."

        if [ "$script_category" = "scheduled" ]; then
            systemctl --user stop "$just_file_name".timer
            systemctl --user disable "$just_file_name".timer
            echo "$HOME/.config/systemd/user/$just_file_name.timer"
            rm "$HOME/.config/systemd/user/$just_file_name.timer"
            echo "Systemd user service file removed."
        
        fi
        
        systemctl --user stop "$just_file_name".service
        systemctl --user disable "$just_file_name".service
        echo "$HOME/.config/systemd/user/$just_file_name.service"
        rm "$HOME/.config/systemd/user/$just_file_name.service"
        echo "Systemd user service file removed."

}


function add_script(){
    new_script_path=$1
    new_script_name=$(basename "$new_script_path")
    option="$2"
    schedule="$3"

    if [ -f "config.json" ]; then
        if grep -q "\"name\": \"$new_script_name\"" config.json; then
            echo "Script with the same name already exists in config.json."
            exit 1
        else
            jq ".$option += [{\"name\": \"$new_script_name\", \"path\": \"$new_script_path\"}]" config.json > temp.json
            mv temp.json config.json
            echo "New script added to config.json."
        fi

    else
        echo '{"startup": [], "shutdown": [], "scheduled": []}' > config.json
        jq ".$option += [{\"name\": \"$new_script_name\", \"path\": \"$new_script_path\"}]" config.json > temp.json
        mv temp.json config.json
        echo "New script added to config.json."
    fi

    if [ ! -d "$HOME/OSALT/scripts/$option" ]; then
        mkdir -p "$HOME/OSALT/scripts/$option"
    fi
    cp "$new_script_path" "$HOME/OSALT/scripts/$option/"
    chmod +x "$HOME/OSALT/scripts/$option/$new_script_name"

    just_file_name="$(basename "$new_script_name" ".sh")"

    if [ "$option" = "startup" ]; then
        echo "
[Unit]
Description=$just_file_name

[Service]
Type=oneshot
ExecStartPre=/bin/sleep 10
ExecStart=$HOME/OSALT/scripts/$option/$new_script_name

[Install]
WantedBy=default.target
        
        " >> "$HOME"/.config/systemd/user/"$just_file_name".service
    systemctl --user enable "$just_file_name".service

    elif [ "$option" = "shutdown" ]; then
    echo "
[Unit]
Description=$just_file_name

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/true
ExecStart=$HOME/OSALT/scripts/$option/$new_script_name

[Install]
WantedBy=default.target
" >> "$HOME"/.config/systemd/user/"$just_file_name".service
    systemctl --user enable "$just_file_name".service

    elif [ "$option" = "scheduled" ]; then
        echo "
[Unit]
Description=$just_file_name

[Service]
Type=oneshot
ExecStart=$HOME/OSALT/scripts/$option/$new_script_name

" >> "$HOME"/.config/systemd/user/"$just_file_name".service

        echo "
[Unit]
Description=$just_file_name

[Timer]
OnCalendar=$schedule
Persistent=true

[Install]
WantedBy=timers.target
" >> "$HOME"/.config/systemd/user/"$just_file_name".timer
    systemctl --user enable "$just_file_name".timer

    fi

}
#systemd-analyze verify ~/.config/systemd/user/test.timer
#systemd-analyze verify ~/.config/systemd/user/test.service
if [ "$#" -lt 1 ]; then
    show_help
    exit 1
fi


while [ "$#" -gt 0 ]; do
    case "$1" in
        -s|--script)
            file="$2"
            option="startup"
            add_script "$file" "$option"
            shift 2
            ;;
        
        -w|--shutdown)
            file="$2"
            option="shutdown"
            add_script "$file" "$option"
            shift 2
            ;;
        
        -c|--scheduled)
            file="$2"
            option="scheduled"
            schedule="$3"
            add_script "$file" "$option" "$3"
            shift 3
            ;;
        
        -d|--delete)
            delete_script "$2"
            shift 2
            ;;
        
        -l|--list)
            list_scripts
            exit 0
            ;;
        
        -h|--help)
            show_help
            exit 1
            ;;
        *)
            echo "Please pass an argument"
            show_help
            exit 1
            ;;
    esac
done

