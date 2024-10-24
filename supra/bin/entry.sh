#!/bin/bash


launch_apps() {
    source run-apps.sh
    jobs -l
    echo "apps launched"
}

echo ''
echo ''
printenv | sort -f
echo 'above are envs app faced'
echo ''
echo ''

launch_apps

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
echo 'exiting....'
jobs -l

#sleep infinity

exit $?
