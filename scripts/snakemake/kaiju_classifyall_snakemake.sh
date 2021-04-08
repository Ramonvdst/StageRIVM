#!/bin/bash

#settings and directories
nodes="/mnt/db/wgs_identification/kaiju_db/nr/nodes.dmp"
names="/mnt/db/wgs_identification/kaiju_db/nr/names.dmp"
rank="genus"  #can be everything from superkingdom to species
rank2="species"
database="/mnt/db/wgs_identification/kaiju_db/nr/kaiju_db_nr.fmi"
inputfile=$1
outputfile=$2



#runs Kaiju for all R1 and R2 files in var "inputfile"
for i in ${inputfile} ; do
    #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfile, if input folder changes, change trimID!
    trimID="${i#*kai_*}"            #removes the first part of the filename before the ID
    sampleID="${trimID%_out*}"      #removes the rest after the ID so you end up with only the filename's ID


    bsub -q bio -o bsubsummarylog_${sampleID}.txt -K kaiju2table -t ${nodes} -n ${names} -r ${rank} -o kai_${sampleID}_${rank} ${i}
    bsub -q bio -o bsubsummarylog_${sampleID}.txt -K kaiju2table -t ${nodes} -n ${names} -r ${rank2} -o kai_${sampleID}_${rank2} ${i}

    
done;

#Converts the bsub output from tab delimited to csv
tr '\t' ',' <kai_${sampleID}_${rank}> kai_${sampleID}_${rank}.csv
tr '\t' ',' <kai_${sampleID}_${rank2}> kai_${sampleID}_${rank2}.csv

#removes tab delimited files
rm kai_${sampleID}_${rank}
rm kai_${sampleID}_${rank2}
