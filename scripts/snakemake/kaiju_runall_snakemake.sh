#!/bin/bash

#settings and directories
nodes=/mnt/db/wgs_identification/kaiju_db/nr/nodes.dmp
database=/mnt/db/wgs_identification/kaiju_db/nr/kaiju_db_nr.fmi
inputfile=$1
outputfile$2
threads=6
mode=greedy       #only use "greedy" or "mem", default greedy
mismatch=-e 3     #only use when mode="greedy" if mem leave empty, default "-e 3" with quotations
minlenght=11        #minimum match length, default 11
minscore=-s 65    #minimum match score in greedy, only use when mode=greedy else leave empty, default "-s 65" with quotations
filenames=()
summarylogname="KAI_JOB_SUMMARY"


#runs Kaiju for all R1 and R2 files in var "inputfile"
for i in ${inputfile} ; do
    #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfolder if input folder changes, change trimID!
    trimID="${i#*test_samples/fastq_gz/}" #removes the first part of the filename before the ID
    sampleID=${trimID%_*} #removes the rest after the ID so you end up with only the filename's ID
    
    
    #replaces R1 with R2 for paired-end file   
    R2File="R2"
    j=${i/R1/$R2File}
    
    bsub -q bio -n ${threads} -o kai_bsublog_${sampleID}.txt -K kaiju -z ${threads} -t ${nodes} -f ${database} -i ${i} -j ${j} -o $2 -a ${mode} -m ${minlenght} ${mismatch} ${minscore}

    #adds file ID to filenames array
    filenames+=(${trimID})
done;

