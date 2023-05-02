#!/bin/bash
# Usage: ./juno_nextflow.sh run pipelines/main.nf
module load java/jdk-11.0.11
module load singularity/3.7.1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

SHIMDIR="${HOME}/.nextflow_shims"

mkdir -p "$SHIMDIR"

export PATH="$PATH:$SHIMDIR"

# Test if `nextflow` is on the PATH
if ! command -v nextflow &> /dev/null
then
    wget -qO- https://get.nextflow.io > "${SHIMDIR}/nextflow"
    chmod +x "${SHIMDIR}/nextflow"
fi


export NEXTFLOW_CONFIG="${NEXTFLOW_CONFIG:=${SCRIPT_DIR}/nextflow.config}"

# Set project specfic env variables
mkdir -p ${HOME}/.singularity/cache/nextflow
export NXF_SINGULARITY_CACHEDIR="${NXF_SINGULARITY_CACHEDIR:=${HOME}/.singularity/cache/nextflow}"

# Run nextflow and pass through args
exec "nextflow" -c "${NEXTFLOW_CONFIG}" "$@"