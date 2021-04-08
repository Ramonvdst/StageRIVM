#!/home/stoopvdr/.conda/envs/pandas_env/bin/python
import pandas as pd
import sys 

#arguments as inputfilesinputfiles 
inputfile1=sys.argv[1]
inputfile2=sys.argv[2]
monsternr=sys.argv[3]

print("starting combining " + inputfile1 + " with " + inputfile2)
#stores argument 1 and 2 as dataframes
df_genus =      pd.read_csv(inputfile1)
df_species =    pd.read_csv(inputfile2)

#appends both dataframes
df_combined = df_genus.append(df_species)
print("combine complete")

#sorts combined dataframe by 'percent' column (extended sort) ands stores it in a new dataframe called df_combined_sorted
df_combined_sorted = df_combined.sort_values(by='percent', ascending=False, ignore_index=True)

#df_combined_sorted is exported as csv with the monsternr argument
df_combined_sorted.to_csv('kai_' + monsternr + '_report.csv')
print ("combined file stored as: " + 'kai_' + monsternr + '_report.csv')