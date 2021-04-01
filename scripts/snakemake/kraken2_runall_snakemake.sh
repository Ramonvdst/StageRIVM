#!/bin/bash

#settings and directories
database=/mnt/db/kraken2-microbial-fatfree
inputfile=$1
outputfile=$2
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
    bsub -q bio -n ${threads} -o kra_bsublog_${sampleID}.txt -K kraken2 --paired --db ${database} ${i} ${j} --threads ${threads} --report ${outputfile} --output kra_${sampleID}_out
    #echo "bsub -q bio -n ${threads} -o ${outputfolder}bsublog_${sampleID}.txt kraken2 --paired --db ${database} ${i} ${j} --threads ${threads} --report ${outputfolder}kra_${sampleID}_report --output ${outputfolder}${sampleID}.out"


    #adds file ID to filenames array
    filenames+=(${trimID})          
done;


