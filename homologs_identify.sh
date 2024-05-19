#!/bin/bash

query_seqs=$1
genome_assembly=$2
bed_file=$3
outfile=$4

# tblastn blasts protein queries against translated nucleotide subject

tblastn \
	-query $query_seqs \
	-subject $genome_assembly \
	-outfmt '6 std qlen' \
	-task tblastn-fast \
| awk '$3>30 && $4>0.9*$13' > identified_homologs.txt

domain_start=()
cut -f 9 identified_homologs.txt > column9.txt
while read -r column_value; do
	domain_start+=("$column_value")
done < column9.txt

domain_stop=()
cut -f 10 identified_homologs.txt > column10.txt
while read -r column_value; do
	domain_stop+=("$column_value")
done < column10.txt

while read sseqid start end label score strand; do
	for i in ${!domain_start[@]} ; do
		if [[ $start -lt $end && ${domain_start[i]} -lt ${domain_stop[i]} ]]; then
			if [[ $start -le ${domain_start[i]} && $end -ge ${domain_stop[i]} ]]; then
				echo $label >> temp_output.txt
			else
				continue
			fi
		elif [[ $start -gt $end && ${domain_start[i]} -gt ${domain_stop[i]} ]]; then
			if [[ $start -ge ${domain_start[i]} && $end -le ${domain_stop[i]} ]]; then
				echo $label >> temp_output.txt
			else
				continue
			fi
		elif [[ $start -lt $end && ${domain_start[i]} -gt ${domain_stop[i]} ]]; then
			if [[ $start -le ${domain_stop[i]} && $end -ge ${domain_start[i]} ]]; then
				echo $label >> temp_output.txt
			else
				continue
			fi
		elif [[ $start -gt $end && ${domain_start[i]} -lt ${domain_stop[i]} ]]; then
			if [[ $start -ge ${domain_stop[i]} && $end -le ${domain_start[i]} ]]; then
				echo $label >> temp_output.txt
			else
				continue
			fi
		else
			continue
		fi
	done
done < "$bed_file"

sort -u -k1,1 temp_output.txt > $outfile

rm identified_homologs.txt
rm column9.txt
rm column10.txt
rm temp_output.txt

number_of_genes=$(wc -l < $outfile)
echo "$number_of_genes genes identified in $genome_assembly"