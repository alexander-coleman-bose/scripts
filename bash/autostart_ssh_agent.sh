#!/usr/bin/env bash
# Script to start/find ssh-agent on login
# Author: Alex Coleman
# Source: https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
# Automatically finds or starts ssh-agent PID and saves PID to SSH_ENV
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" > /dev/null

    # Add existing keys to ssh-agent
    for f in ~/.ssh/id_*[!.pub]; do
        /usr/bin/ssh-add "$f"
    done
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    source "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep "${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
