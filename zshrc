# path

# brew doctor
# export PATH="/opt/homebrew/sbin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"

export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# history

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# functions

function mvpkg () {
mv Documents/AppToPKG/*/*.pkg Desktop/new
}

function info () {
if [[ -e $1 ]]; then
	short=$( defaults read $1/Contents/Info.plist CFBundleShortVersionString )
	echo "Short version:  " $short
	echo "Long version:   " $( defaults read $1/Contents/Info.plist CFBundleVersion )
	echo "Bundle ID:      " $( defaults read $1/Contents/Info.plist CFBundleIdentifier )
	echo "Developer ID:   " $( /usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "Developer ID Application" | /usr/bin/cut -d ':' -f2 | /usr/bin/xargs )
	echo "Team ID:        " $( /usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "TeamIdentifier" | /usr/bin/cut -d '=' -f2 )
	echo "regex:           (copied to pasteboard)" $( ~/regex.sh $short | tail -n 2 | pbcopy)
else
	echo "No app found"
fi	
}

function x1info () {
echo "Short version:  " $( defaults read $1/Contents/Info.plist CFBundleShortVersionString )
echo "Long version:   " $( defaults read $1/Contents/Info.plist CFBundleVersion )
echo "Bundle ID:      " $( defaults read $1/Contents/Info.plist CFBundleIdentifier )
echo "Developer ID:   " $( /usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "Developer ID Application" | /usr/bin/cut -d ':' -f2 | /usr/bin/xargs )
echo "Team ID:        " $( /usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "TeamIdentifier" | /usr/bin/cut -d '=' -f2 )
}

function vers () {
defaults read $1/Contents/Info.plist CFBundleShortVersionString
}

function lvers () {
defaults read $1/Contents/Info.plist CFBundleVersion
}

function devID () {
/usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "Developer ID Application" | /usr/bin/cut -d ':' -f2 | /usr/bin/xargs
}

function teamID () {
/usr/bin/codesign -dvv "$1" 2>&1 | /usr/bin/grep "TeamIdentifier" | /usr/bin/cut -d '=' -f2
}

function pwr () {
pmset -g batt | awk 'NR==2 { print $3 " " $4 }' | sed 's/;//g'
}

function rev() {
rowa
rod
rmst
}

function rowa() {
osascript -e 'tell application "Outlook (PWA)" to quit'
sleep 1
osascript -e 'tell application "Outlook (PWA)" to activate'
} 

function rod() {
pkill OneDrive
sleep 2
osascript -e 'tell application "OneDrive" to activate'
}

function rmst() {
osascript -e 'tell application "Microsoft Teams" to quit'
sleep 2
osascript -e 'tell application "Microsoft Teams" to activate'
}

function dud() {
diskutil unmount /Volumes/Distpoint
}
function jtail () {
tail -f /var/log/jamf.log | awk '{for(i=1;i<=NF;i++){ if($i~/Execut|Install|Success/) $i=sprintf("\033[0;36m%s\033[0;00m",$i)}; $5=""; sub(/  /, " "); print}'
}

# aliases

alias ffs="sudo !! "
alias ll="ls -la | more"
alias lt="ls -lt | more"

alias history="history -f"

alias pip-upgrade="python3 -m pip install --upgrade pip"

alias muc="~/.cargo/bin/muc -f ~/.zsh_history | head -n 10"

alias greedy="autopkg repo-update all ; autopkg run --recipe-list ~/Library/Application\ Support/AutoPkgr/recipe_list.txt --report-plist /private/tmp/autopkg-report.xml ; brew update ; brew upgrade --cask --greedy ; brew upgrade $(brew outdated | awk '{ print $1 }') ; brew cleanup ; sudo jamf recon ; date"

alias caf="caffeinate -di &"
alias halfcaf="caffeinate -i &"
alias decaf="pkill caffeinate"

alias source=". ~/.zshrc && echo 'zsh config reloaded from ~/.zshrc'"
alias reload=". ~/.zshrc && echo 'zsh config reloaded from ~/.zshrc'"

export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
