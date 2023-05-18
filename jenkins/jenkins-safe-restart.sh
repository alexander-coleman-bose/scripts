#!/usr/bin/env bash
# jenkins-safe-restart.sh
# Requires the curl command, and a Jenkins API Token with admin permissions

# Alex St. Amour

this='jenkins-safe-restart.sh'
JENKINS_URL='example.com/jenkins'
API_CALL_JOBS='api/xml?tree=jobs\[name,url,color\]&xpath=/hudson/job\[ends-with(color/text(),%22_anime%22)\]&wrapper=jobs'
API_CALL_SHUTDOWN='safeRestart'

# Read the Jenkins API token
read -srp "Enter a Jenkins API token: " api_token
if [ -z "$api_token" ]; then
    echo "$this:ERROR:API Token is empty, quitting..." >&2
    exit -1
fi
echo ""

# Get a list of currently running jobs
# https://devops.stackexchange.com/questions/1537/jenkins-api-call-or-groovy-builtin-that-returns-list-of-all-currently-running
current_jobs_raw=$(curl -sX POST "http://admin:$api_token@$JENKINS_URL/$API_CALL_JOBS" | grep -oP "(?<=<name>).*?(?=</name>)")
if [ -z "$current_jobs_raw" ]; then
    echo "$this:INFO:No jobs are currently running."
else
    current_jobs_array=($current_jobs_raw)
    echo "$this:INFO:Currently running jobs:"
    printf "$this:INFO:\t%s\n" "${current_jobs_array[@]}"
fi

# Prevent new builds, wait for currently running builds, then shutdown
echo "$this:INFO:Shutting down the Jenkins service..."
if curl -X POST "http://admin:$api_token@$JENKINS_URL/$API_CALL_SHUTDOWN"; then
    echo "$this:INFO:Jenkins has been sent the shutdown command."
else
    echo "$this:ERROR:Unable to send Jenkins the shutdown command. Check that you have the correct token." >&2
    exit -1
fi
