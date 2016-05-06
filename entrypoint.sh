#!/bin/bash
set -e

INSTALL_DIR=/ppmessage
cd ${INSTALL_DIR}

if [ ! -e "$INSTALL_DIR/ppmessage/bootstrap/config.py" ];then
    echo "Can't find config.py, please try again."
    exit 1
fi

bash dist.sh dev
bash dist.sh bootstrap
bash dist.sh bower
bash dist.sh npm
bash dist.sh gulp
bash dist.sh start

exec "$@"