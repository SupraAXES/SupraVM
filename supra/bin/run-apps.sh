function parse_apps() {
    echo SUPRA_APPS $SUPRA_APPS
    local IFS=','
    read -ra RUN_APPS <<< "$SUPRA_APPS"
}

function run_app() {
    cd /home/supra
    while : ; do
        cmd="/supra/bin/launchers/$1.sh"
        echo run-app $cmd
        $cmd
        sleep 5
        [[ -v SUPRA_APPS_LOOP_ON ]] || break
    done
}

parse_apps
for app in "${RUN_APPS[@]}"; do
    run_app $app &
done
