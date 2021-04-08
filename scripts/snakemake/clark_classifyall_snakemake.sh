#!/bin/bash

#settings and directories


#$1 = outputfile
#$2 = inputfile
database="/mnt/db/wgs_identification/clark_db"
inputfile=$2



# test (){
# echo "Who is the best? $1 is $2!"
# }

# test "Sanne" "awesome"

# trim () {
#     trimID="${($1#$2)}"            
#     sampleID="${trimID%$3}"
    
#     return echo bsub -q bio -o clarkbsubsummarylog_${sampleID}.txt "/home/stoopvdr/.conda/envs/CLARK/opt/clark/exe/getAbundance -F ${i} -D ${database}>${outputfolder}/cla_${sampleID}_report.csv"    
# }


#runs Kaiju for all R1 and R2 files in var "inputfile"
for i in ${inputfile} ; do
        
    #trims Filename to ID string only, for ID use sampleID var !Hardcoded for inputfile, if input folder changes, change trimID!
    trimID="${i#*cla_*}"            #removes the first part of the filename before the ID
    sampleID="${trimID%_out*}"      #removes the rest after the ID so you end up with only the filename's ID
    bsub -q bio -o clarkbsubsummarylog_${sampleID}.txt -K "/home/stoopvdr/.conda/envs/CLARK/opt/clark/exe/getAbundance -F ${i} -D ${database}>$1" 
    #bsub -q bio -o clarkbsubsummarylog_${sampleID}.txt "/home/stoopvdr/.conda/envs/CLARK/opt/clark/estimate_abundance.sh -F ${i} -D ${database}>${outputfolder}/cla_${sampleID}_report2.csv"
    #bsub -q bio -o clarkbsubsummarylog_${sampleID}.txt "/home/stoopvdr/.conda/envs/CLARK/opt/clark/evaluate_density_confidence.sh -F ${i} -D ${database}>${outputfolder}/cla_${sampleID}_report3.csv" 
    

done;


# bsub -q bio -o /mnt/scratch_dir/stoopvdr/output_folder/run_3/getabundance.txt "/home/stoopvdr/.conda/envs/CLARK/opt/clark/exe/getAbundance 
# -F /mnt/scratch_dir/stoopvdr/output_folder/run_3/cla_1200000000_out.csv -D /mnt/db/wgs_identification/clark_db>/mnt/scratch_dir/stoopvdr/output_folder/run_3/cla_12000000000_report.csv"