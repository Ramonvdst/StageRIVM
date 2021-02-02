#!/bin/bash


tool=kai
inputfile=${tool}_*


for i in ${inputfile} ; do
        
    #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfile, if input folder changes, change trimID!
    trimID="${i#*${tool}_*}"            #removes the first part of the filename before the ID
    sampleID="${trimID%_*}"      #removes the rest after the ID so you end up with only the filename's ID
    
    tr '\t' ',' <${i}> ${tool}_${sampleID}_report.csv

done;


#tr '\t' ',' <kra_1160000000_report.tsv> file.csv
