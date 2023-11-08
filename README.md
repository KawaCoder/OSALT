# OSALT 🧂 (Under development)
## Table of content:
#### [1. Todo list](https://github.com/KawaCoder/OSALT#todo)
#### [2. Usage](https://github.com/KawaCoder/OSALT#todo)
#### [3. Contact](https://github.com/KawaCoder/OSALT#todo)

<p align="center">
    <img src="https://img.shields.io/badge/100%25-Bash-black.svg?style=for-the-badge&logo=shell&logoColor=white" />&nbsp;&nbsp;
    <a href="[https://www.mozilla.org/en-US/MPL/](https://www.gnu.org/licenses/gpl-3.0.html)">
      <img src="https://img.shields.io/badge/License-GPL%203.0-darkgreen.svg?style=for-the-badge&logo=GNU" />
    </a>
  </p>

OSALT: Open-source Scripting Automation Linux Toolkit is a tool that helps with scheduled scripting automation on Linux systems
The code will be in bash. It is an implementation of systemd.
## TODO:
#### Coding features
- [x] Set up statup script
  - [x] Add script to config.json
  - [x] Copy script to config directory and change rights
  - [x] Create systemd service
  - [x] Enable service
- [x] Set up shutdown script
  - [x] Add script to config.json
  - [x] Copy script to config directory and change rights
  - [x] Create systemd service
- [ ] Set up scheduled script
  - [x] Add script to config.json
  - [x] Copy script to config directory and change rights
  - [ ] Create systemd service
  - [ ] Create systemd timer
- [x] List user's scripts
- [x] Delete scripts
  - [x] Remove script from folder
  - [x] Disable systemd service
  - [x] Delete systemd service
- [ ] Disable script
- [ ] Set up triggered script

#### Other
- [x] See how to set up run at start (systemctl/cron/?)
- [x] See how to set up run at shutdown

## Usage
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
### To set up scheduled script, use systemd OnCalendar syntax:
https://wiki.archlinux.org/title/Systemd/Timers

| Explanation                | Systemd timer                      |
|----------------------------|-----------------------------------|
| Every Minute               | `*-*-* *:*:00`                   |
| Every 2 minutes            | `*-*-* *:*/2:00`                 |
| Every 5 minutes            | `*-*-* *:*/5:00`                 |
| Every 15 minutes           | `*-*-* *:*/15:00`                |
| Every quarter hour         | `*-*-* *:*/15:00`                |
| Every 30 minutes           | `*-*-* *:*/30:00`                |
| Every half an hour         | `*-*-* *:*/30:00`                |
| Every 60 minutes           | `*-*-* */1:00:00`                |
| Every 1 hour               | `*-*-* *:00:00`                  |
| Every 2 hours              | `*-*-* */2:00:00`                |
| Every 3 hours              | `*-*-* */3:00:00`                |
| Every other hour           | `*-*-* */2:00:00`                |
| Every 6 hours              | `*-*-* */6:00:00`                |
| Every 12 hours             | `*-*-* */12:00:00`               |
| Hour Range                 | `*-*-* 9-17:00:00`               |
| Between certain hours     | `*-*-* 9-17:00:00`               |
| Every day                  | `*-*-* 00:00:00`                 |
| Daily                      | `*-*-* 00:00:00`                 |
| Once A day                 | `*-*-* 00:00:00`                 |
| Every Night                | `*-*-* 01:00:00`                 |
| Every Day at 1am          | `*-*-* 01:00:00`                 |
| Every day at 2am          | `*-*-* 02:00:00`                 |
| Every morning              | `*-*-* 07:00:00`                 |
| Every midnight             | `*-*-* 00:00:00`                 |
| Every day at midnight      | `*-*-* 00:00:00`                 |
| Every night at midnight    | `*-*-* 00:00:00`                 |
| Every Sunday               | `Sun *-*-* 00:00:00`             |
| Every Friday               | `Fri *-*-* 01:00:00`             |
| Every Friday at midnight  | `Fri *-*-* 00:00:00`             |
| Every Saturday             | `Sat *-*-* 00:00:00`             |
| Every weekday              | `Mon...Fri *-*-* 00:00:00`       |
| Weekdays only              | `Mon...Fri *-*-* 00:00:00`       |
| Monday to Friday           | `Mon...Fri *-*-* 00:00:00`       |
| Every weekend              | `Sat,Sun *-*-* 00:00:00`         |
| Weekends only              | `Sat,Sun *-*-* 00:00:00`         |
| Every 7 days               | `* *-*-* 00:00:00`                |
| Every week                | `Sun *-*-* 00:00:00`             |
| Weekly                     | `Sun *-*-* 00:00:00`             |
| Once a week                | `Sun *-*-* 00:00:00`             |
| Every month                | `* *-*-01 00:00:00`               |
| Monthly                    | `* *-*-01 00:00:00`               |
| Once a month               | `* *-*-01 00:00:00`               |
| Every quarter              | `* *-01,04,07,10-01 00:00:00`    |
| Every 6 months             | `* *-01,07-01 00:00:00`          |
| Every year                 | `* *-01-01 00:00:00`             |



## Contact
<a href="mailto:kawacoder@duck.com">
  <img src="https://img.shields.io/badge/Email%20me-darkred?style=for-the-badge&logo=gmail&logoColor=white"/>
</a>
