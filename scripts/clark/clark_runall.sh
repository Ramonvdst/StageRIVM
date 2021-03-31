#!/bin/bash

#settings and directories
database=/mnt/db/wgs_identification/clark_db
targetfile=/mnt/db/wgs_identification/clark_db/targets.txt
inputfolder=/mnt/scratch_dir/stoopvdr/test_samples/fastq/
outputfolder=/mnt/scratch_dir/stoopvdr/output_folder/run_3/
inputfile=/mnt/scratch_dir/stoopvdr/test_samples/fastq/*R1*
threads=6
kmersize=21
mode=0
filenames=()
summarylogname="CLA_JOB_SUMMARY"

#runs CLARK for all R1 and R2 files in var "inputfile"
for i in ${inputfile} ; do
    #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfile, if input folder changes, change trimID!
    trimID="${i#*test_samples/fastq/}"
    sampleID=${trimID%_*}
    
    
    #replaces R1 with R2 for paired-end file   
    R2File="R2"
    j=${i/R1/$R2File}

    #CLARK command
    bsub -q bio -n ${threads} -o ${outputfolder}cla_bsublog_${sampleID}.txt CLARK -n ${threads} -k ${kmersize} -T ${targetfile} -D ${database} -P ${i} ${j} -R ${outputfolder}cla_${sampleID}_out -m ${mode}

    #adds file ID to filenames array
    filenames+=(${trimID})
    #sleep 1m #testing if computercluster doesnt like al tasks at once.   
done;

#summarylog, dont add options below files used.
echo "${summarylogname} send to ${outputfolder}"
echo " --JOB SUMMARY--
input folder:   ${inputfolder}
output folder:  ${outputfolder}
database:       ${database}
threads:        ${threads}
files used:">>${outputfolder}${summarylogname}.txt
for i in "${filenames[@]}"; do
 
    echo "$i" >>${outputfolder}${summarylogname}.txt; 
done;

#   bsub -q bio -n 4 -o output.txt CLARK -k 31 -T /mnt/db/wgs_identification/clark_db/targets.txt -D /mnt/db/wgs_identification/clark_db 
#   -P /mnt/scratch_dir/stoopvdr/test_samples/1071900063_R1.fastq.gz /mnt/scratch_dir/stoopvdr/test_samples/1071900063_R2.fastq.gz -R testresult.csv -n 4

