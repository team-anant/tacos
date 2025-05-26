#!/bin/bash

# Set the number of threads BitBake can execute simultaneously
export BB_NUMBER_THREADS=12

# Set the number of parallel make threads
export PARALLEL_MAKE="-j 12"

export BB_NUMBER_PARSE_THREADS=12

export DL_DIR="/run/media/dhruv/0d2781b8-a6bd-433a-b06f-2fe56c3c81ae/downloads/"

export SSTATE_DIR="/run/media/dhruv/0d2781b8-a6bd-433a-b06f-2fe56c3c81ae/sstate-cache/"

export TMPDIR="/run/media/dhruv/0d2781b8-a6bd-433a-b06f-2fe56c3c81ae/tmp/"

# export KAS_MACHINE="qemuarm"
