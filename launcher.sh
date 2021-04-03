# How to use：
#  Launch dcokcer [Up]
#    ./docker.sh -u
#    Build docker image
#    ./docker.sh -u --build
#
#  Down Dcokcer [Down]
#    ./docker.sh -d
#

#!/bin/zsh'
SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

abort() { echo "$*" >&2; exit 1; }
unknown() { abort "unrecognized option '$1'"; }

up() {
    echo "up ... ${ARG_OPTION}"
    docker-compose -f ./provisioning/docker/docker-compose.yml up -d ${ARG_OPTION}
}

down() {
    echo "down ..."
    docker-compose -f ./provisioning/docker/docker-compose.yml down
}

while [ $# -gt 0 ]; do
    case $1 in
        -u | --up ) shift; ARG_OPTION=$1; up ;;
        -d | --down ) down ;;
        -?*) unknown "$@" ;;
        *) break
    esac
    shift
done
