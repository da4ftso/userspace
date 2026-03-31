# path

# export PATH="/opt/homebrew/sbin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"

export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

export upped=$(date +%y%m%d)

# functions

function randpw {
  local len="${1:-16}"

  if ! command -v openssl >/dev/null; then
    echo "openssl not found"
    return 1
  fi

  # Generate and filter to safe chars (alphanumeric + - _)
  local pw
  pw=$(openssl rand -base64 48 \
        | tr -dc 'A-Za-z0-9._-' \
        | head -c "$len") || return 1

  print -r -- "$pw" | pbcopy
  print -r -- "$pw"
}

function beep() {
for i in {1..$1}; do tput bel; done
}

function mvapp() {
mv ~/Documents/AppToPKG/*/*.pkg ~/Desktop/new
}

function last_policy() {
if [[ $EUID == 0 ]]; then
  history -100 | awk 'match($0, /-event[[:space:]]+/) { print $2 "\t" substr($0, RSTART+RLENGTH) }' 
else
  echo "jamf policy was probably running from root; sudo won't work here."
fi
}

function last_uploads() {
history -100 |
awk '
/history/ { next }

BEGIN { printed=0 }

{
  for (i=1; i<=NF; i++)
    if ($i ~ /^[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{4}$/) { split($i,d,"/"); md=d[1]"/"d[2]; break }

  match($0, /--name "[^"]+"/)
  if (RSTART) {
    name = substr($0, RSTART+8, RLENGTH-9)
    if (!printed) { print ""; printed=1 }   # one leading blank line
    print md, name
  }
}

END { if (printed) print "" }               # one trailing blank line
'
}

function model() {
/usr/sbin/sysctl -n hw.model
}

function mdfindq() {
mdfind -name $1 2>&1 | grep -v UserQueryParser 
}

function rowa() {
osascript -e 'tell application "Outlook (PWA)" to quit'
sleep 1
osascript -e 'tell application "Outlook (PWA)" to activate'
}

function rod() {
osascript -e 'tell application "OneDrive" to quit'
sleep 2
osascript -e 'tell application "OneDrive" to activate'
}

function info () {
echo "Short version:  " $( defaults read $1/Contents/Info.plist CFBundleShortVersionString )
echo "Long version:   " $( defaults read $1/Contents/Info.plist CFBundleVersion )
echo "Bundle ID:      " $( defaults read $1/Contents/Info.plist CFBundleIdentifier )
echo "Developer ID:   " $( /usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "Developer ID Application" | /usr/bin/cut -d ':' -f2 | /usr/bin/xargs )
echo "Team ID:        " $( /usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "TeamIdentifier" | /usr/bin/cut -d '=' -f2 )
}

function pwr () {
echo $(pmset -g batt | awk ' NR==2 { print $3 " " $4 " " $5 } ')
}

function jtail () {
tail -f /var/log/jamf.log | awk '{for(i=1;i<=NF;i++){ if($i~/Execut|Success/) $i=sprintf("\033[0;36m%s\033[0;00m",$i)}; \
{if($i~/failed/) $i=sprintf("\031[0;36m%s\031[0;00m",$i)}; $5=""; $6=""; sub(/  /, ""); print}'
}

# function jtail () {
# tail -f /var/log/jamf.log | awk '{for(i=1;i<=NF;i++){ if($i~/Execut|Success/) $i=sprintf("\033[0;36m%s\033[0;00m",$i)}; $5=""; sub(/  /, " "); print}'
# }


# aliases

alias bbed="open -a BBEdit $1"

alias ffs="sudo !! "
alias ll="ls -la | more"
alias lt="ls -lt | more"

alias dud="diskutil unmount /Volumes/Distpoint"

alias history="history -f"

alias recon="/usr/local/bin/jamf recon"
alias qrecon="/usr/local/bin/jamf recon > /dev/null 2>&1"

alias muc="~/.cargo/bin/muc -f ~/.zsh_history | head -n 10"

alias greedy="autopkg repo-update all ; \
 autopkg run --recipe-list ~/Library/Application\ Support/AutoPkgr/recipe_list.txt --report-plist /private/tmp/autopkg-report.xml ; \
 open Library/AutoPkg/Cache/ ; \
 /opt/homebrew/bin/brew update ; \
 /opt/homebrew/bin/brew upgrade --cask --greedy ; \
 /opt/homebrew/bin/brew upgrade $(/opt/homebrew/bin/brew outdated | awk '{ print $1 }') ; \
 /opt/homebrew/bin/brew cleanup ; \
 sudo jamf recon > /dev/null 2>&1 ; \
 date"

alias caf="caffeinate -di &"
alias decaf="pkill caffeinate"

alias source=". ~/.zshrc && echo 'zsh config reloaded from ~/.zshrc'"
alias reload=". ~/.zshrc && echo 'zsh config reloaded from ~/.zshrc'"

alias pip-upgrade="python3 -m pip install --upgrade pip"

export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/unzip/bin:$PATH"
export PATH="/opt/homebrew/opt/m4/bin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export INSOMNIA_DISABLE_AUTOMATIC_UPDATES=true
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

