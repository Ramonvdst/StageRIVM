#!/bin/bash
#*grabs all S, S1, S2, G, G1 and G2's from a kra_*_report file in the folder 


inputfile=kra_*

for i in ${inputfile} ; do
    #IF file is named *_fullreport then it will: grab al S>G variations and create a temp file containing them.
    #tr: converts tsv to csv and removes temporary file afterwards.
    if [[ ${i} == *_fullreport ]]
        then
            #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfile, if input folder changes, change trimID!
            trimID="${i#*kra_*}"            #removes the first part of the filename before the ID
            sampleID="${trimID%_report*}"      #removes the rest after the ID so you end up with only the filename's ID

            grep -w "S\|S1\|S2\|G\|G1\|G2" kra_${sampleID}_fullreport >kra_${sampleID}_temp

            #grep -w "S\|S1\|S2\|G\|G1\|G2" kra_${sampleID}_sorted >kra_temp_${sampleID}_report
            #sort -nr kra_temp_${sampleID}_report > kra_${sampleID}_refined
            #rm kra_temp_${sampleID}_report

            tr '\t' ',' <kra_${sampleID}_temp> kra_${sampleID}_report.csv
            rm kra_${sampleID}_temp 
        else
            continue
    fi
    
done;
echo "kraken_isolateGS.sh, Done."





