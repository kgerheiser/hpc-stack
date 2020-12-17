#!/bin/bash
set -eu

cron_dir=${HPC_DOWNLOAD_PATH}/hpc-stack/cron-ci

if [[ "$TEST_UFS" == true ]]; then
    # mm-dd-yyy-hh:mm
    ufs_logdate=$(date +'%m-%d-%Y-%R')
    ufs_logname=ufs_${ufs_logdate}.log
    ufs_log=${HPC_LOG_PATH}/${ufs_logname}

    git --version
    ufs_hash=$(git -C ${HPC_DOWNLOAD_PATH}/ufs-weather-model rev-parse HEAD)
    
    
    echo ""
    echo "testing ufs-weather-model..."
    echo ""
    echo "UFS hash: ${ufs_hash}"
    echo "UFS log: ${ufs_log}"
    echo ""
    
    ${cron_dir}/test-ufs.sh >> ${ufs_log} 2>&1

    # check if ufs regression tests were successful
    if grep -qi "REGRESSION TEST WAS SUCCESSFUL" ${ufs_log}; then
        echo "UFS regression tests: PASS"
    else
        echo "UFS regression tests: FAIL"
    fi
fi

