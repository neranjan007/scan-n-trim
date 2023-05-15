version 1.0

import "../tasks/task_fastqReadCount.wdl" as fqReadCount 
import "../tasks/task_trimmomatic.wdl" as trimmomatic 

workflow peTrimming_workflow{
    input{
        File R1
        File R2
    }

    # tasks and/or subworkflows to execute
    call fqReadCount.fastqReadCount_task {
        input:
            read1 = R1,
            read2 = R2

    }

    call trimmomatic.trimmomatic_task{
        input:
            r1 = R1,
            r2 = R2
    }

    call fqReadCount.fastqReadCount_task as trimedFastqReadCount_task {
        input:
            read1 = trimmomatic_task.r1_paired, 
            read2 = trimmomatic_task.r2_paired
    }
    output{
        String R1_read_count = fastqReadCount_task.r1_read_count
        String R2_read_count = fastqReadCount_task.r2_read_count
        String R1_trim_read_count = trimedFastqReadCount_task.r1_read_count
        String R2_trim_read_count = trimedFastqReadCount_task.r2_read_count
    }

}