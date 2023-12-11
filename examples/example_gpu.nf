nextflow.enable.dsl=2

log.info """\
You're now running a nextflow pipeline on the GPU.
"""

process myprocess {
    // This is translated to the bsub -R "rusage[mem=XXX]" parameter (memory)
    memory '2 GB'
    // This is translated to the bsub -W parameter
    time '1h'
    // This is translated to the -n parameter in bsub
    cpus 1
    // If you leave this line the process is run in this singularity container, if you delete this line it will run on the host
    container = "docker://python:3.10"
    // If you leave this line here as is this the process is run on LSF, if you delete this line it will run locally
    executor = "lsf"
    // Queue the job on the GPU using lsf
    queue 'gpuqueue'
    // Arguments to be passed to LSF to run on a single GPU with 8GB of memory
    clusterOptions '-gpu "num=1:gmem=8"'
    // Singularity requires this flag to allow for containers to access the GPU
    containerOptions = '--nv'

    input:
        val data

    output:
        path 'result', emit: result

    script:
    """
    echo "$data" > result
    """
}


workflow {
   myprocess("hello world")
}