#!/bin/sh
# $Id: .bash_profile,v 1.87 2012/02/09 18:00:22 denplusplus Exp $

shopt -s histappend
export HISTFILESIZE=200000
#export HISTIGNORE="&:ls:bg:fg:ps x:exit"
#export PROMPT_COMMAND='history -a; echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD}\007"'
if test ${USER} = "denplusplus"
then
    SUSER=""
else
    SUSER="${USER}@"
fi
export PROMPT_COMMAND='history -a; echo -ne "\033]0;${SUSER}${HOSTNAME%%.*}:${PWD}\007"'

export CLICOLOR=1
export PATH=~/bin/bin:$PATH:/sbin:/usr/sbin:/Berkanavt/bin/scripts
export CVSROOT=tree.yandex.ru:/opt/CVSROOT
export SVNROOT=svn+ssh://arcadia.yandex.ru/arc
export SVNROOT_=svn+ssh://arcadia.yandex.ru/arc/trunk/arcadia
export EDITOR=vim
export OBJDIRPREFIX=/home/denplusplus/obj
export MAKEOBJDIRPREFIX=/home/denplusplus/obj
export LD_LIBRARY_PATH=~/bin/lib:${LD_LIBRARY_PATH}
export HISTFILESIZE=200000

export CVS_RSH=ssh
export EMAIL=denplusplus@yandex-team.ru

OS=`uname -s`
HOSTNAME=`hostname`

if test ${OS} = "Darwin"
then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH
    if [ -f /sw/bin/init.sh ]; then
        . /sw/bin/init.sh
    fi
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH

    if [-f ~/.bashrc]; then
        . ~/.bashrc
    fi
fi

if test ${OS} = "FreeBSD"
then
    alias amake="make"
else
    alias amake="pmake"
fi

alias ls="ls -l"
alias topu="top -U denplusplus"
alias setru='export LANG=ru_RU.KOI8-R'
alias grepc='find . \( -name \*.cpp -o -name \*.h -o -name \*.cc -o -name \*.hh -o -name \*.c -o -name \*.dbc -o -name \*.l -o -name \*.y -o -name \*.rl \) | grep -v .svn |  xargs grep -n'
alias greph='find . \( -name \*.h -o -name \*.hh  \) | grep -v .svn | xargs egrep -n'
alias grepm='find . \( -name CMakeLists.\*  \) | grep -v .svn | xargs egrep -n'
alias greps='find . | grep -v .svn | xargs egrep -n'
alias pushdd='pushd `pwd`'
alias vim='vim -p'
alias gvim='gvim -p'
alias m='ssh -L 2222:arcadia.yandex.ru:22 -L 3333:tree.yandex.ru:22 -L 10002:maitai.yandex.ru:10002 -A maitai.yandex.ru -L 10003:walruseng000.yandex.ru:10003'
alias ycvs='echo "ssh -p 3333 \$*" >~/bin/bin/treessh; chmod +x ~/bin/bin/treessh; CVSROOT=localhost:/opt/CVSROOT CVS_RSH=~/bin/bin/treessh cvs'
alias Rsync='rsync -rptzL --progress --inplace --rsh=ssh'
alias cMake.py='~/work/arcadia/cmake/scripts/cMake.py'
alias m2='ssh -L 2222:arcadia.yandex.ru:22 -L 3333:tree.yandex.ru:22 -L 10002:mojito.yandex.ru:10002 -A mojito.yandex.ru'
alias s='ssh -L 2222:arcadia.yandex.ru:22 -L 3333:tree.yandex.ru:22 -L 10002:ssd-test:10002 -A ssd-test.yandex.ru -L 10003:walruseng000.yandex.ru:10003'

vd()
{
    vimdiff $1/$3 $2/$3
}

svndi()
{
    svn di $* | vim - -R
}

cvsdi()
{
    cvs di $* | vim - -R
}

go()
{
    ssh -A denplusplus@$1.yandex.ru
}

gogo()
{
    ssh -At maitai.yandex.ru "ssh -At denplusplus@$1.yandex.ru"
}

monitor()
{
    while [ 1 ]; do clear; $1; sleep 3; done
}

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

mkHome()
{
    USER=$1
    mkdir /home/$1
    chown $1:$1 /home/$1
    chmod g-w /home/$1
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

YR()
{
    yr $1 PRINTSERVERLIST | xargs -I % rsh % "$2"
}

alias toScripts="cd ~/work/arcadia/junk/denplusplus/scripts"
alias gP="~/genProject.py"

if test ${HOSTNAME} != "denplusplus-nb"
then
    export TERM=xterm-color
fi

if test ${HOSTNAME} = "arc.yandex.ru" -o ${HOSTNAME} = "glagol.yandex.ru" -o ${HOSTNAME} = "daiquiri.yandex.ru" -o ${HOSTNAME} = "fireball" -o ${HOSTNAME} = "den-ubuntu" -o ${HOSTNAME} = "shaman" -o ${HOSTNAME} = "boogie8.yandex.ru"
then
    alias ls="ls -l --color=yes"
    alias mc="mc -c"
    alias mcedit="mcedit -c"
    alias emacs="emacs --color=always"
    export LD_LIBRARY_PATH=/large/X11R6/lib:${LD_LIBRARY_PATH}
else
    alias grep='grep --color'
fi

if test $OS = "Linux"
then
    alias ls="ls -l --color=yes"
fi

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

case "$TERM" in
xterm-color)
 PS1='\[\033[36m\]\A \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
 ;;
*)
 PS1='\A \u@\h:\w\$ '
 ;;
esac

export LANG=en_US.UTF-8

# . ~/.bash_profile_memsql

