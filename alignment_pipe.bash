fastq="/home/owens/working/germplasm/fastq"
ngm="/home/owens/bin/NextGenMap-0.4.12/bin/ngm-0.4.12/ngm"
ref="/home/owens/ref/HA412.v1.1.bronze.20141015.fasta"
bam="/home/owens/working/germplasm/bam"
picardtools='/home/owens/bin/picard-tools-2.1.0'
log="/home/owens/working/germplasm/log"
project="germplasm"
home="/home/owens/working/germplasm"
bin="/home/owens/bin"
javarules="-Djava.io.tmpdir=/media/owens/speedy/tmp"
demultiplex='/home/owens/bin/GBS_fastq_Demultiplexer_v8.GO.pl'
plate="germplasm"
trim="/home/owens/bin/Trimmomatic-0.32"
trimmeddata="/home/owens/working/germplasm/trimmed"
unpaired="/home/owens/working/germplasm/orphaned"
ncores="9"


#ls $fastq | grep -v "nobar" | sed s/_R1//g | sed s/_R2//g | sed s/.fastq// | uniq  > $home/Samplelist.$plate.txt
#Trim the data using Trimmomatic. Removes bad reads and illumina adapter contamination.
#while read prefix
#do
#java -jar $trim/trimmomatic-0.32.jar PE -phred33 $fastq/"$prefix"_R1.fastq $fastq/"$prefix"_R2.fastq $trimmeddata/"$prefix"_R1.fastq $unpaired/"$prefix"_unR1.fastq $trimmeddata/"$prefix"_R2.fastq $unpaired/"$prefix"_unR2.fastq ILLUMINACLIP:$trim/adapters/TruSeq3-PE.fa:2:30:10:8:T SLIDINGWINDOW:4:15 MINLEN:36
#done < Samplelist.$plate.txt
ls  $trimmeddata | grep -v "nobar" | sed s/_1//g | sed s/_2//g | sed s/.fq// | uniq  > $home/Samplelist.$plate.txt
while read name
do    
	echo "Aligning paired $name"
    $ngm -r $ref -p --qry1 $trimmeddata/${name}_1.fq --qry2 $trimmeddata/${name}_2.fq -o $bam/$name.paired.bam -t $ncores -b
    echo "Aligning unpaired $name"
    $ngm -r $ref -q $unpaired/${name}_un1.fq  -o $bam/$name.R1.unpaired.bam -t $ncores -b
    $ngm -r $ref -q $unpaired/${name}_un2.fq  -o $bam/$name.R2.unpaired.bam -t $ncores -b

    echo "Processing for $name"
	java $javarules -jar $picardtools/picard.jar MergeSamFiles I=$bam/$name.paired.bam I=$bam/$name.R1.unpaired.bam I=$bam/$name.R2.unpaired.bam O=$bam/$name.merged.bam VALIDATION_STRINGENCY=LENIENT COMPRESSION_LEVEL=0
        /home/owens/bin/samtools-1.3/samtools view -h $bam/$name.merged.bam > $bam/$name.merged.sam
        /home/owens/bin/samtools-1.3/samtools view -hSb $bam/$name.merged.sam > $bam/$name.merged.bam
	java $javarules -jar $picardtools/picard.jar SortSam I=$bam/$name.merged.bam O=$bam/$name.merged.v1.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT COMPRESSION_LEVEL=0
	java $javarules -jar $picardtools/picard.jar AddOrReplaceReadGroups I=$bam/$name.merged.v1.bam O=$bam/$name.merged.v2.bam \
	RGID=$name RGLB=$project RGPL=ILLUMINA RGPU=$project RGSM=$name SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT COMPRESSION_LEVEL=0
	java $javarules -jar $picardtools/picard.jar CleanSam I=$bam/$name.merged.v2.bam O=$bam/$name.bam VALIDATION_STRINGENCY=LENIENT
	rm $bam/$name.merged.sam
	rm $bam/$name.merged.bam
	rm $bam/$name.merged.v1.bam
	rm $bam/$name.merged.v2.bam
done < $home/Samplelist.$plate.txt
