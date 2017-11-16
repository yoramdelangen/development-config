# Devlopment alias
alias art='php artisan'
alias subl='open -a Sublime\ Text'
alias pstorm='open -a PhpStorm'
alias ip='ifconfig | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"'
alias ngrok='~/.ngrok'
alias myssh='cat ~/.ssh/id_rsa.pub'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gs='git status -u'
alias gt='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias commit='git commit'
alias status='git status -u'
alias checkout='git checkout'
alias branch='git branch'
alias stash='git stash'
alias gd='git diff'
alias gu='git tag'
alias cdu='composer dump-autoload'
alias cu='composer update'
alias ci='composer install'

# Quick locations/navigation
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ~='cd ~'
alias sites='cd ~/Sites/'
alias code='~/Code/'
alias bc='~/Code/Brandcube'
alias hosts='sudo vim /etc/hosts'
alias known_hosts='sudo vim /Users/yoramdelangen/.ssh/known_hosts'

# Others
alias _=sudo
alias source_bash='source ~/.bash_profile && source ~/.bash_aliases'
alias c='clear'
alias cc="osascript -e 'if application \"iTerm2\" is frontmost then tell application \"System Events\" to keystroke \"k\" using command down'"
alias phpfix='php-cs-fixer fix .  --config=/Users/Yoram/.scripts/php_cs.dist'
alias size='du -hs * | sort -h'

# PHPUnit
alias pu='phpunit'
alias puf='phpunit --filter'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

git_pull() {
    if [ ! -z "$1" ]; then
        echo "Pull from branch => $1"
        git pull -v --stat origin "$1"
    else
        echo "Pull from branch => $(parse_git_branch)"
        git pull -v --stat origin "$(parse_git_branch)"
    fi

	git fetch --tags
}
alias pull=git_pull

git_push() {
    if [ ! -z "$1" ]; then
        echo "Push on branch => $1"
        git push -u origin "$1"
    else
        echo "Push on branch => $(parse_git_branch)"
        git push -u origin "$(parse_git_branch)"
    fi
}
alias push=git_push
alias newversion=~/.scripts/new-version.sh

tsa_update()
{
    ## Loop through selective folders if there are folders given
    if [ $# -gt 0 ]; then
        for d in $*; do
            echo "==================== Starting to update in the directory: $d ===================="
            cd $d
            git checkout composer.lock
            pull
            composer update
            php artisan tsa:update
            cd ../
        done
        echo "Finished selected folders"
    else
        echo "Which folder do you want to use?"
        ls -l
    fi
}
alias "tsa-env"=tsa_update

homesteadCommands()
{
    if [ $# -eq 0 ]; then
        echo "Please gife one of the following commands: \n- start \n- stop \n- edit \n- status\n- ssh \n- reload/restart \n- update/provision/prov"
        return
    fi

    CURRENT_DIR=$PWD
    cd ~/.homestead

    case "$1" in
        start|up )
            vagrant up
            ;;
        stop )
            vagrant halt
            ;;
        status )
            vagrant status
            ;;
        edit )
            subl Homestead.yaml
            ;;
        ssh )
            vagrant ssh
            ;;
        update|provision|prov )
            vagrant provision
            ;;
        reload|restart )
            vagrant reload --provision
            ;;
    esac

    cd $CURRENT_DIR
}
alias hs=homesteadCommands
