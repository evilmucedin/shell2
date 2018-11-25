#!/bin/sh

if test ${HOSTNAME} != "denplusplus-nb"
then
    export TERM=xterm-color
fi

shopt -s histappend
export HISTFILESIZE=1000000
export HISTSIZE=1000000
#export HISTIGNORE="&:ls:bg:fg:ps x:exit"
if test ${USER} = "denplusplus"
then
    SUSER=""
else
    SUSER="${USER}@"
fi
export CLICOLOR=1
export EDITOR=vim
export CUDA_ROOT=/Developer/NVIDIA/CUDA-7.5

OS=`uname -s`
HOSTNAME=`hostname`

if test ${OS} = "Darwin"
then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    if [ -f /sw/bin/init.sh ]; then
        . /sw/bin/init.sh
    fi
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
fi

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}

FACEBOOK="false"
if [[ $HOSTNAME == *facebook.com ]]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
    echo "Wake up, Neo, you are at work."
    source $ADMIN_SCRIPTS/scm-prompt
    FACEBOOK="true"
    TMUX_REG="'s/^.*=//'"
    # alias tmuxStatus="tmux showenv -g TMUX_LOC_\$(tmux display -p \"#D\" | tr -d %) | sed $TMUX_REG"
    # export PS1=$PS1'$( [ -n "$TMUX" ] && tmux setenv -g TMUX_LOC_$(tmux display -p "#D" | tr -d %) "$(_dotfiles_scm_info)")'
    alias buckPath='PT=$(realpath .); echo ${PT:40}'
    alias push='/usr/local/bin/push_parallel'

    function bb() {
      buck build -j 80 $* `buckPath`/...
    }
fi

export FACEBOOK_DS1='dev11889.prn2.facebook.com'
export FACEBOOK_DS2='dev9537.prn1.facebook.com'
export FACEBOOK_DS3='devbig284.frc2.facebook.com'

alias ds1="mosh --no-init -6 ${FACEBOOK_DS1}"
alias ds2="mosh --no-init -6 ${FACEBOOK_DS2}"
alias ds3="mosh --no-init -6 ${FACEBOOK_DS3}"

alias grep='grep --color'
alias egrep='egrep --color'
alias topu="top -U denplusplus"
alias grepc='find . \( -name \*.cpp -o -name \*.h -o -name \*.cc -o -name \*.hh -o -name \*.c -o -name \*.dbc -o -name \*.l -o -name \*.y -o -name \*.rl \) | grep -v .svn | xargs grep -n --color'
alias greph='find . \( -name \*.h -o -name \*.hh -o -name \*.hpp \) | grep -v .svn | xargs egrep -n --color'
alias grepm='find . \( -name CMakeLists.\* -o -name TARGETS  \) | grep -v .svn | xargs egrep -n --color'
alias greps='find . -type f | grep -v .svn | xargs egrep -n --color'
alias grept='find . \( -name \*.thrift \) | grep -v .svn | xargs egrep -n --color'
alias pushdd='pushd `pwd`'
alias vim='vim -p'
alias gvim='gvim -p'
alias Rsync='rsync -rptzL --progress --inplace --rsh=ssh'
alias vimall='vim $(hg chg -n)'
alias less='less -r'

vd()
{
    vimdiff $1/$3 $2/$3
}

monitor()
{
    while [ 1 ]; do
      clear; 
      $1; 
      sleep 3; 
    done
}

NoHup2()
{
    CMD=$1
    NAME=$2
    nohup nice -n 20 $CMD </dev/null >$NAME.out 2>$NAME.err &
}

NoHup()
{
    CMD=$1
    NoHup2 "$CMD" "nohup"
}

if test $OS = "Linux"
then
    alias ls="ls -l --color=yes"
fi

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
case "$TERM" in
xterm-color)
  if [ $FACEBOOK == "true" ] && [ ! `_dotfiles_scm_info` == *'not found'* ]; then
    PS1='\[\033[36m\]\A \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;35m\]$(_dotfiles_scm_info)\[\033[00m\]\$ '
  else
    PS1='\[\033[36m\]\A \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  fi
 ;;
*)
 PS1='\A \u@\h:\w\$ '
 ;;
esac

export LANG=en_US.UTF-8

toBuck()
{
    DIR=`pwd`
    BUCK_DIR=${DIR/fbcode/fbcode\/buck-out\/gen}
    pushd $DIR
    cd $BUCK_DIR
}

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >"${SSH_ENV}"
    if [ $FACEBOOK == "true" ]; then
        echo export SSH_AUTH_SOCK=/var/run/ssh-agent/agent.111114 >>"${SSH_ENV}"
    fi
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" >/dev/null
    /usr/bin/ssh-add
}

# Source SSH settings, if applicable

if test ${OS} = "Linux"; then
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_agent;
        }
    else
        start_agent;
    fi
fi

if test "${HOSTNAME}" = "${FACEBOOK_DS}" || test "${HOSTNAME}" = "${FACEBOOK_DS1}" || test "${HOSTNAME}" = "${FACEBOOK_DS2}" || test "${HOSTNAME}" = "${FACEBOOK_DS3}"; then
    if [ "$TERM" != "nuclide" ] && [ -t 0 ] && [ -z "$TMUX" ] && which tmux >/dev/null 2>&1 && [[ "`tmux -V`" == "tmux 1.8" || "`tmux -V`" == "tmux 2.2" ]]; then
      if tmux has-session -t auto >/dev/null 2>&1; then
        echo "Neo, attaching tmux."
        tmux -2 attach-session -t auto
      else
        echo "Neo, launching tmux."
        tmux -2 new-session -s auto
      fi
    fi
fi

export FB_UID=100011223126069

if [ $FACEBOOK == "true" ]; then
    return
fi

# Yandex related stuff

alias setru='export LANG=ru_RU.KOI8-R'

copyAuthSSH()
{
    SERVER=$1
    echo copy to $SERVER
    ssh $SERVER "rm -rf .ssh"
    scp -rp ~/.ssh $SERVER:
}

copyAuth()
{
    SERVER=$1
    echo copy to $SERVER
    rsh $SERVER "rm -rf .ssh"
    rcp -rp ~/.ssh $SERVER:
}

mkHome()
{
    USER=$1
    mkdir /home/$1
    chown $1:$1 /home/$1
    chmod g-w /home/$1
}

svndi()
{
    svn di $* | vim - -R
}

cvsdi()
{
    cvs di $* | vim - -R
}

if test ${OS} = "FreeBSD"
then
    alias amake="make"
else
    alias amake="pmake"
fi

export PATH=~/bin/bin:$PATH:/sbin:/usr/sbin:/Berkanavt/bin/scripts
export CVSROOT=tree.yandex.ru:/opt/CVSROOT
export SVNROOT=svn+ssh://arcadia.yandex.ru/arc
export SVNROOT_=svn+ssh://arcadia.yandex.ru/arc/trunk/arcadia
export OBJDIRPREFIX=/home/denplusplus/obj
export MAKEOBJDIRPREFIX=/home/denplusplus/obj
export LD_LIBRARY_PATH=~/bin/lib:${LD_LIBRARY_PATH}
export CVS_RSH=ssh
export EMAIL=denplusplus@yandex-team.ru

alias m='ssh -L 2222:arcadia.yandex.ru:22 -L 3333:tree.yandex.ru:22 -L 10002:maitai.yandex.ru:10002 -A maitai.yandex.ru -L 10003:walruseng000.yandex.ru:10003'
alias ycvs='echo "ssh -p 3333 \$*" >~/bin/bin/treessh; chmod +x ~/bin/bin/treessh; CVSROOT=localhost:/opt/CVSROOT CVS_RSH=~/bin/bin/treessh cvs'
alias cMake.py='~/work/arcadia/cmake/scripts/cMake.py'
alias m2='ssh -L 2222:arcadia.yandex.ru:22 -L 3333:tree.yandex.ru:22 -L 10002:mojito.yandex.ru:10002 -A mojito.yandex.ru'
alias s='ssh -L 2222:arcadia.yandex.ru:22 -L 3333:tree.yandex.ru:22 -L 10002:ssd-test:10002 -A ssd-test.yandex.ru -L 10003:walruseng000.yandex.ru:10003'

if test ${HOSTNAME} = "arc.yandex.ru" || test ${HOSTNAME} = "maitai.yandex.ru" || test ${HOSTNAME} = "svarog.yandex.ru" || test ${HOSTNAME} = "ssd-test.yandex.ru"
then
    alias run_proxy="~/bin/bin/proxy -p10002 -i0.0.0.0 -e0.0.0.0"
fi

if test ${HOSTNAME} = "walruseng000.yandex.ru"
then
    alias run_proxy="~/bin/bin/proxy -p10003 -i0.0.0.0 -e0.0.0.0"
fi

if test ${HOSTNAME} = "maitai.yandex.ru" || test ${HOSTNAME} = "ssd-test.yandex.ru"
then
     run_proxy &
fi

if test ${HOSTNAME} = "daiquiri"
then
    export LANG=
fi

if test ${HOSTNAME} = "mojito.yandex.ru"
then
    ulimit -u 2048
    ulimit -c unlimited
fi

alias toScripts="cd ~/work/arcadia/junk/denplusplus/scripts"
alias gP="~/genProject.py"

if test ${HOSTNAME} = "arc.yandex.ru" -o ${HOSTNAME} = "glagol.yandex.ru" -o ${HOSTNAME} = "daiquiri.yandex.ru" -o ${HOSTNAME} = "fireball" -o ${HOSTNAME} = "den-ubuntu" -o ${HOSTNAME} = "shaman" -o ${HOSTNAME} = "boogie8.yandex.ru"
then
    alias ls="ls -l --color=yes"
    alias mc="mc -c"
    alias mcedit="mcedit -c"
    alias emacs="emacs --color=always"
    export LD_LIBRARY_PATH=/large/X11R6/lib:${LD_LIBRARY_PATH}
else
    alias grep='grep --color'
    alias egrep='egrep --color'
fi

copySettings()
{
    SERVER=$1
    echo copy settings to ${SERVER}
    copyAuth $SERVER
    rsh ${SERVER} "mkdir s; cd s; cvs -d tree.yandex.ru:/opt/CVSROOT co -P test/denplusplus/shell; for f in \`ls -A1 test/denplusplus/shell\`; do rm -rf ~/\$f; mv -f test/denplusplus/shell/\$f ~/\$f; done; rm -rf ~/s"
}

copySettingsSSH()
{
    SERVER=$1
    echo copy settings to ${SERVER}
    copyAuthSSH $SERVER
    ssh ${SERVER} "export CVS_RSH=ssh; mkdir s; cd s; cvs -d tree.yandex.ru:/opt/CVSROOT co -P test/denplusplus/shell; for f in \`ls -A1 test/denplusplus/shell\`; do rm -rf ~/\$f; mv -f test/denplusplus/shell/\$f ~/\$f; done; rm -rf ~/s"
}

go()
{
    ssh -A denplusplus@$1.yandex.ru
}

gogo()
{
    ssh -At maitai.yandex.ru "ssh -At denplusplus@$1.yandex.ru"
}

YR()
{
    yr $1 PRINTSERVERLIST | xargs -I % rsh % "$2"
}

alias crontab="VIM_CRONTAB=true crontab"
export force_color_prompt=yes
export color_prompt=yes

alias ubuntu_up="sudo apt-get update; sudo apt-get dist-upgrade; sudo apt-get autoremove"
export UBUNTU_PACKAGES="vim python3-pip g++ clang-format gnome-tweak-tool chromium-browser ant gnome-shell-extension-system-monitor cmake ubuntu-restricted-addons ubuntu-restricted-addons git ctags vlc libboost-all-dev cabextract font-manager powertop atop tmux wavemon gnuplot-x11 meld tmux"

case ${TERM} in
    xterm-color*)
        if [ "$TMUX" != "" ] ; then
            # user command to change default pane title on demand
            function title {
                TMUX_PANE_TITLE="$*";
            }

            # function that performs the title update (invoked as PROMPT_COMMAND)
            function update_title {
                s=${1:0:16};
                printf "\033k%s\033\\" "${s:-$TMUX_PANE_TITLE}";
            }

            # default pane title is the name of the current process (i.e. 'bash')
            TMUX_PANE_TITLE=$(ps -o comm $$ | tail -1);

            # Reset title to the default before displaying the command prompt
            PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'update_title'

            # Update title before executing a command: set it to the command
            trap 'update_title "$BASH_COMMAND"' DEBUG
        fi

    ;;
esac
