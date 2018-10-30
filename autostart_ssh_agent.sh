#!/usr/bin/env bash
# Script to start/find ssh-agent on login
# Alex Coleman
# Source: https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login

# The following code with start ssh-agent for a single login session:
eval $(ssh-agent -s) # BASH command
# eval `ssh-agen -c` # CSH command
ssh-add # Adds keys to ssh-agent

# Add the following to your .bash_profile so that it is run for every login, not
# just interactive logins

# Automatically finds or starts ssh-agent PID and saves PID to SSH_ENV
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
