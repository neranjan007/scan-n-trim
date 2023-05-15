version 1.0

task fastqReadCount_task{
	meta {
		description: "Read the number of reads in a fastq file gz ziped"
	}

	input{
		#task inputs
		File read1
		File read2
		String docker = "staphb/fastq-scan:0.4.4"
		Int cpu = 1
		Int memory = 1
	}

	command <<<
		zcat ~{read1} | fastq-scan | jq .qc_stats.read_total > TOTAL_R1_READS
		zcat ~{read2} | fastq-scan | jq .qc_stats.read_total > TOTAL_R2_READS
		cat TOTAL_R1_READS
		cat TOTAL_R2_READS
	>>>

	output{
		String r1_read_count = read_string("TOTAL_R1_READS")
		String r2_read_count = read_string("TOTAL_R2_READS")
	}

	runtime {
		# runtime environment
		docker: "~{docker}"
		memory: "~{memory} GB"
		cpu: cpu
		disks: "local-disk 50 SSD"
		preemptible: 0
	}
}

