#!/home/stoopvdr/.conda/envs/pandas_env/bin/python
import pandas as pd 
print("Working...")

#input files
cla_df = pd.read_csv('/mnt/scratch_dir/stoopvdr/output_folder/combine/cla_1160000000_report.csv')
kra_df = pd.read_csv('/mnt/scratch_dir/stoopvdr/output_folder/combine/kra_1160000000_refined.csv')
kai_df = pd.read_csv('/mnt/scratch_dir/stoopvdr/output_folder/combine/kai_1160000000_report.csv')

#adds columnnames to each table, relevant columns are named, others are marked A->F
cla_df.columns = ['clark_name','b','c','d','e','clark_result']
kra_df.columns = ['kraken2_result','b','c','d','e','kraken2_name']
kai_df.columns = ['a','kaiju_result','c','d','kaiju_name']

print(".")

combined_format = {
    "file_name": [],
    "clark_name": [],
    "clark_result": [],
    "kaiju_name": [],
    "kaiju_result": [],
    "kraken2_name": [],
    "kraken2_result": []
}
cdf = pd.DataFrame(combined_format)

#sorts result data in descending order, also index remains 0-n with ignore_index=True
cla_sort = cla_df.sort_values(by='clark_result', ascending=False, ignore_index=True)
kra_sort = kra_df.sort_values(by='kraken2_result', ascending=False, ignore_index=True)
kai_sort = kai_df.sort_values(by='kaiju_result', ascending=False, ignore_index=True)

print("..")

#omits results which are above a given threshold < or > than X, also resets indeces so alignment keeps working. removes spaces in front of name.
# kra_sort['kraken2_result'] = kra_sort[kra_sort['kraken2_result'] < 95.0]['kraken2_result']
# kra_sort_2 = kra_sort.dropna().reset_index()
kra_sort['kraken2_name'] = kra_sort['kraken2_name'].str.replace(" ","")

print("...")

#picks top 5 of each dataframe, and only the columns 'name' and 'result'
cla_head5 = cla_sort.head(5)[['clark_name','clark_result']]
kra_head5 = kra_sort.head(5)[['kraken2_name','kraken2_result']]
kai_head5 = kai_sort.head(5)[['kaiju_name','kaiju_result']]

print("....")

#cdf = pd.concat([cla_df[['clark_name','clark_result']], kra_df[['kraken2_name','kraken2_result']], kai_df[['kaiju_name','kaiju_result']]], axis=1)
#concatenates the top 5 of the filtered tool resutls
cdf = pd.concat([cla_head5,kra_head5,kai_head5], axis=1)

print(".....")

#saves dataframe to CSV file
cdf.to_csv(r'/mnt/scratch_dir/stoopvdr/output_folder/combine/combined_file_v3.csv')

print("done")
