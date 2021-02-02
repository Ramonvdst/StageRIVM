#!/bin/bash

#settings and directories
database=/mnt/db/kraken2-microbial-fatfree
outputfolder=/mnt/scratch_dir/stoopvdr/output_folder/run_3/
inputfile=/mnt/scratch_dir/stoopvdr/test_samples/fastq_gz/*R1*
inputfolder=/mnt/scratch_dir/stoopvdr/test_samples/fastq_gz/
threads=6
filenames=()
summarylogname="KRA_JOB_SUMMARY"

#runs Kraken2 for all R1 and R2 files in var "inputfile"
for i in ${inputfile} ; do
    #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfile, if input folder changes, change trimID!
    trimID="${i#*test_samples/fastq_gz/}"
    sampleID=${trimID%_*}
    
    
    #replaces R1 with R2 for paired-end file   
    R2File="R2"
    j=${i/R1/$R2File}

    #run kraken command
    bsub -q bio -n ${threads} -o ${outputfolder}kra_bsublog_${sampleID}.txt kraken2 --paired --db ${database} ${i} ${j} --threads ${threads} --report ${outputfolder}kra_${sampleID}_fullreport --output ${outputfolder}kra_${sampleID}_out
    #echo "bsub -q bio -n ${threads} -o ${outputfolder}bsublog_${sampleID}.txt kraken2 --paired --db ${database} ${i} ${j} --threads ${threads} --report ${outputfolder}kra_${sampleID}_report --output ${outputfolder}${sampleID}.out"


    #adds file ID to filenames array
    filenames+=(${trimID})          
done;


#summarylog, dont add options below files used.
echo "${summarylogname} send to ${outputfolder}"
echo " --JOB SUMMARY--
input folder:   ${inputfolder}
output folder:  ${outputfolder}
database:       ${database}
threads:        ${threads}
files used:">${outputfolder}${summarylogname}.txt
for i in "${filenames[@]}"; do
 
    echo "$i" >>${outputfolder}${summarylogname}.txt; 
done;



# bsub -q bio -n 12 -o job_1091702139.txt 
# kraken2 --gzip-compressed 
# --paired –db /mnt/db/kraken2-microbial-fatfree /mnt/scratch_dir/stoopvdr/test_samples/1091702139_R1.fastq.gz /mnt/scratch_dir/stoopvdr/test_samples/1091702139_R2.fastq.gz 
# --threads 12 --report 1091702139_report 
# --output 1091702139.out