while read chr
do
ls bam | grep ${chr}.bam | grep -v bai | sed s/^/bam\\//g > bamlist.${chr}.txt
#freebayes --min-coverage 5 --report-monomorphic --use-best-n-alleles 4 -f /home/owens/ref/HA412.v1.1.bronze.20141015.fasta -L bamlist.${chr}.txt  > germplasm.freebayes.${chr}.vcf
/home/owens/bin/freebayes/scripts/freebayes-parallel <(/home/owens/bin/freebayes/scripts/fasta_generate_regions.py /home/owens/ref/HA412.v1.1.bronze.20141015.fasta.fai 100000) 1  --report-monomorphic --use-best-n-alleles 4 -f /home/owens/ref/HA412.v1.1.bronze.20141015.fasta -L bamlist.${chr}.txt > germplasm.freebayes.${chr}.vcf

done < chrlist.txt
