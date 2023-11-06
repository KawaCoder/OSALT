# OSALT 🧂 (Under development)
OSALT: Open-source Scripting Automation Linux Toolkit is a tool that helps with scheduled scripting automation on Linux systems
The code will be in bash.
### TODO:
#### Coding features
- [x] Set up statup script
  - [x] Add script to config.json
  - [x] Copy script to config directory and change rights
  - [x] Create systemd service
  - [x] Enable service
- [ ] Set up shutdown script
  - [x] Add script to config.json
  - [x] Copy script to config directory and change rights
  - [ ] Create systemd service/set up run on shutdown?
- [ ] Set up scheduled script
  - [x] Add script to config.json
  - [x] Copy script to config directory and change rights
  - [ ] configure cron
- [x] List user's scripts
- [x] Delete scripts
  - [x] Remove script from folder
  - [x] Disable systemd service
  - [x] Delete systemd service
- [ ] Disable script

#### Other
- [x] See how to set up run at start (systemctl/cron/?)
- [ ] See how to set up run at shutdown
```
osalt [options] [script_name]

Options:
  -s, --startup <script_name>    Add a startup script.
  -w, --shutdown <script_name>   Add a shutdown script.
  -c, --scheduled <script_name>  Add a scheduled script.
  -d, --delete <script_name>     Delete a script.
  -l, --list                     List all available scripts.
  -h, --help                     Prints this help.

Examples:
  osalt -s my_startup_script.sh
  osalt -h my_shutdown_script.sh
  osalt -c my_scheduled_script.sh
  osalt -v my_startup_script.sh
  osalt -d my_shutdown_script.sh
  osalt -l
```
