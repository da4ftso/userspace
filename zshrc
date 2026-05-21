# PATH

# export PATH="/opt/homebrew/sbin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"

export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

export upped=$(date +%y%m%d)

# FUNCTIONS

function fzf-history() {
  local tmpfile=$(mktemp)

  # Select entries (multi-select)
  grep -n '' ~/.zsh_history | \
    fzf --multi --tac --no-sort \
        --delimiter ':' \
        --with-nth=2.. \
        --preview 'echo {}' \
    > "$tmpfile"

  # Exit if nothing selected
  [[ ! -s "$tmpfile" ]] && { rm -f "$tmpfile"; return; }

  # Build list of line numbers to delete
  local lines=$(cut -d: -f1 "$tmpfile" | sort -rn)

  # Delete from bottom up (so indexes don't shift)
  for l in $lines; do
    sed -i '' "${l}d" ~/.zsh_history
  done

  rm -f "$tmpfile"

  # Reload history
  fc -R ~/.zsh_history

  echo "Deleted $(echo "$lines" | wc -l | tr -d ' ') entries"
}

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
mv -f /Users/u446852/Documents/AppToPKG/DBeaver*/*.pkg(N)  Desktop/new/DBeaver 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Insomnia*/*.pkg(N)  Desktop/new/Insomnia 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/IntelliJ*/*.pkg(N)  Desktop/new/IntelliJ\ ideal 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Podman*/*.pkg(N)  Desktop/new/Podman 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Postman*/*.pkg(N)  Desktop/new/Postman 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Pycharm*/*.pkg(N)  Desktop/new/pycharm 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Rancher*/*.pkg(N)  Desktop/new/Rancher 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Visual\ Studio\ Code*/*.pkg(N)  Desktop/new/Microsoft/Visual\ Studio\ Code 2>/dev/null
mv -f /Users/u446852/Documents/AppToPKG/Webex*/*.pkg(N)  Desktop/new/Cisco/Webex 2>/dev/null
mv -f ~/Documents/AppToPKG/*/*.pkg(N) ~/Desktop/new 2>/dev/null
}

function last_policy() {
if [[ $EUID == 0 ]]; then
  history -100 | awk 'match($0, /-event[[:space:]]+/) { print $2 "\t" substr($0, RSTART+RLENGTH) }' 
else
  echo "jamf policy was probably running from root; sudo won't work here."
fi
}

function jpolicy() {
if [[ $EUID == 0 ]]; then
  history -100 | awk 'match($0, /-event[[:space:]]+/) { print $2 "\t" substr($0, RSTART+RLENGTH) }' 
else
  echo "jamf policy was probably running from root; sudo won't work here."
fi
}

function juploads() {
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
tail -f /var/log/jamf.log | awk '
/patch/ { next }
/recurring/ { next }
/bgrecon/ { next }

{
    for (i = 1; i <= NF; i++) {

        # Cyan
        if ($i ~ /Execut|Success|failed/)
            $i = sprintf("\033[0;36m%s\033[0m", $i)

        # Yellow
        if ($i ~ /Installing/)
            $i = sprintf("\033[0;33m%s\033[0m", $i)

        # Red
        if ($i ~ /Error/)
            $i = sprintf("\033[0;31m%s\033[0m", $i)
    }

    $5 = ""
    $6 = ""
    sub(/  +/, " ")
    print
}'
}

function xjtail () {
tail -f /var/log/jamf.log | awk '{for(i=1;i<=NF;i++){ if($i~/Execut|Success/) $i=sprintf("\033[0;36m%s\033[0;00m",$i)}; \
{if($i~/failed/) $i=sprintf("\031[0;36m%s\031[0;00m",$i)}; $5=""; $6=""; sub(/  /, ""); print}'
}

# function jtail () {
# tail -f /var/log/jamf.log | awk '{for(i=1;i<=NF;i++){ if($i~/Execut|Success/) $i=sprintf("\033[0;36m%s\033[0;00m",$i)}; $5=""; sub(/  /, " "); print}'
# }


function newest() {
local src="$1"
local dest="$2"
local days="${3:-15}"
local dry="$4"

if [[ -z "$src" || -z "$dest" ]]; then
  echo "Usage: newest <src> <dest> [days] [--dry-run]"
  return 1
fi

if [[ ! -d "$src" ]]; then
  echo "Source not found: $src"
  return 1
fi

mkdir -p "$dest" || return 1

local rsync_opts=(-av --files-from=- --from0)

[[ "$dry" == "--dry-run" ]] && rsync_opts+=(--dry-run)

( find "$src" -type f -mtime "-$days" -print0
) | rsync "${rsync_opts[@]}" ./ "$dest"/

}


# ALIASES

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

