# path

# brew doctor
# export PATH="/opt/homebrew/sbin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"

export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# functions

function info () {
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

function jtail () {
tail -f /var/log/jamf.log | awk '{for(i=1;i<=NF;i++){ if($i~/Execut|Success/) $i=sprintf("\033[0;36m%s\033[0;00m",$i)}; print}'
}

# aliases

alias ffs="sudo !! "
alias ll="ls -la | more"
alias lt="ls -lt | more"

alias ntver="/usr/bin/awk '/version/ { print $NF } ' /Library/Application\ Support/Nexthink/config.json | tr -d '",'"

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
