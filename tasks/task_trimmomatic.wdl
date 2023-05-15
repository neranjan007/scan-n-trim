version 1.0

task trimmomatic_task{
    meta{
        description: "Trim the reads in Paired sample"
    }

    input{
        # task inputs
        File r1
        File r2
        String docker = "staphb/trimmomatic:0.39"
        Int cpu = 8
        Int memory = 10
        Int minlen = 75
        Int window_size = 10
        Int required_quality = 20
    }

    String samplename_r1 = basename(r1, '.fastq')
    String samplename_r2 = basename(r2, '.fastq')

    command <<<
        echo "~{r1}"
        echo "~{samplename_r1}"
        echo "~{samplename_r2}"
        trimmomatic PE \
        -threads ~{cpu} \
        "~{r1}" "~{r2}" \
        "~{samplename_r1}_paired.fastq" "~{samplename_r1}_unpaired.fastq" \
        "~{samplename_r2}_paired.fastq" "~{samplename_r2}_unpaired.fastq" \
        ILLUMINACLIP:/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:20:10:8:TRUE \
        SLIDINGWINDOW:~{window_size}:~{required_quality} MINLEN:~{minlen}
        cat stderr
    >>>

    output{
        # task outputs
        #File r1_paired = "r1_paired.fastq"
        #File r2_paired = "r2_paired.fastq"
        File r1_paired = "~{samplename_r1}_paired.fastq"
        File r2_paired = "~{samplename_r2}_paired.fastq"
    }

    runtime{
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}
