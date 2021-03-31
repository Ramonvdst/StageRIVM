#!/bin/bash
# $1 = outputfile
# $2 = inputfile

#settings and directories
database=/mnt/db/wgs_identification/clark_db
targetfile=/mnt/db/wgs_identification/clark_db/targets.txt
inputfile=$2
threads=6
kmersize=21
mode=0
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
    bsub -q bio -n ${threads} -o cla_bsublog_${sampleID}.txt -K CLARK -n ${threads} -k ${kmersize} -T ${targetfile} -D ${database} -P ${i} ${j} -R $1 -m ${mode}

    #adds file ID to filenames array
    filenames+=(${trimID})
   # sleep 1m #testing if computercluster doesnt like al tasks at once.   
done;

# CLARK always puts out a .csv extention, this resulted in an output with .csv.csv... you cannot remove .csv from the snakemake logic, so this is a fix for that.
while [ ! -f cla_${sampleID}_out.csv.csv ] 
do
    sleep 2
done

mv cla_${sampleID}_out.csv.csv cla_${sampleID}_out.csv


# mv cla_${sampleID}_out.csv.csv cla_${sampleID}_out
# mv cla_${sampleID}_out cla_${sampleID}_out.csv
