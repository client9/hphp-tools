#!/bin/bash
set -e
export HPHP_ROOT=/usr/local/hphp-root
export HPHP_SRC=/usr/local/hphp-src
export HPHP_TAR=/usr/local/hphp-tar

sudo rm -rf ${HPHP_ROOT} ${HPHP_SRC} ${HPHP_TAR}
